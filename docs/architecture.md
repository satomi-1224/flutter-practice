# Architecture & Directory Structure

## 1. 概要 (Overview)

本プロジェクトは、**Feature-First (機能単位)** のディレクトリ構成を採用したFlutterアプリケーションです。
バックエンドに **BFF (Backend For Frontend / Laravel)** が存在することを前提とし、クライアントサイドでの複雑なデータ変換を避け、UI構築と状態管理に注力する **MVVM + Atomic Design** アーキテクチャを採用しています。

### 技術スタック (Tech Stack)
* **Framework:** Flutter
* **State Management:** Riverpod (Notifier / AsyncNotifier)
* **Routing:** GoRouter
* **HTTP Client:** Dio + Retrofit
* **Data Class:** Freezed + JsonSerializable
* **UI Design:** Atomic Design
* **Testing:** flutter_test (Unit/Widget), Maestro (E2E / 別リポジトリ運用)

---

## 2. ディレクトリ構成 (Directory Structure)

トップレベルと機能モジュール内部で構成を統一する「フラクタル構造」を採用しています。

```text
lib/
├── config/              # 環境変数 (Env), 定数
│
├── pages/               # 【画面カタログ】 (Routing Endpoints)
│   ├── home/
│   ├── auth/
│   │   └── login_page.dart
│   └── products/
│       └── product_list_page.dart
│
├── features/            # 【機能モジュール】 (Vertical Slices)
│   ├── auth/
│   └── products/
│       ├── infra/       # API通信・Repository実装
│       ├── models/      # Data Model (BFFレスポンス / Freezed)
│       ├── controllers/ # State Management (Riverpod Notifier)
│       ├── containers/  # Logic Binding (Smart UI)
│       └── widgets/     # View Implementation (Dumb UI / Atomic Design)
│           ├── molecules/
│           └── organisms/
│
├── widgets/             # 【汎用UI】 (Atomic Design / Shared)
│   ├── atoms/           # ボタン, アイコン, テキスト
│   ├── molecules/       # リストタイル, フォーム入力
│   └── layouts/         # 共通レイアウト枠 (Scaffold wrapper)
│
├── infra/               # 【全域基盤】 (Infrastructures)
│   ├── api/             # Dio設定, Interceptors
│   ├── generated/       # ★OpenAPI等の自動生成コード (Lint除外)
│   └── exceptions/      # 共通例外定義
│
├── routes/              # 【ルーティング】 Route定義 (GoRouter)
├── theme/               # デザイン定義 (ThemeData, Colors)
├── utils/               # ヘルパー関数 (Extensions, Formatters)
├── app.dart             # MaterialApp
└── main.dart            # Entry Point

```

---

## 3. 各層の役割 (Layer Responsibilities)

### 3.1. Pages (`lib/pages/`)

* **役割:** ルーティングの終端（URLと対になるファイル）。
* **責務:**
* `widgets/layouts` (共通枠) の呼び出し。
* `features/.../containers` (機能コンテナ) の配置。
* **禁止事項:** 複雑なロジック記述、直接のAPIコール。



### 3.2. Features (`lib/features/`)

機能ごとの「縦割り」モジュール。原則として他機能の内部実装（Controller/Repository）に依存してはならない。

| ディレクトリ | 役割 | 詳細 |
| --- | --- | --- |
| **`infra`** | Data Layer | APIクライアント(Retrofit)とRepositoryの実装。 |
| **`models`** | Data Model | BFFからのレスポンス定義。EntityとDTOを兼ねる。 |
| **`controllers`** | Logic | `Notifier` / `AsyncNotifier` による状態管理とビジネスロジック。 |
| **`containers`** | **Smart UI** | Controller(`ref`)とWidgetを繋ぐ結合層。データを取得し、Viewに渡す。 |
| **`widgets`** | **Dumb UI** | ロジックを持たない純粋な表示部品。Atomic Designで構成。 |

### 3.3. Widgets (`lib/widgets/`)

特定のFeatureに依存しない、アプリ全体で再利用可能なUIコンポーネント。Atomic Designに準拠する。

### 3.4. Infra (`lib/infra/`)

アプリ全体を支える技術基盤。

* **`generated`**: OpenAPI等から自動生成されたコードを配置。`analysis_options.yaml` でLint対象外に設定する。

### 3.5. Routes (`lib/routes/`)

画面遷移の定義。

* **`app_router.dart`**: GoRouterの設定本体。
* **`app_routes.dart`**: パスやルート名の定数定義、またはTyped Routes定義。

---

## 4. データフロー (Data Flow)

**MVVM** パターンに基づき、データとイベントは以下のフローで処理されます。

```mermaid
graph TD
    User((User))
    
    subgraph ViewLayer ["View Layer"]
        Page[Page<br>lib/pages]
        Container[Container (Smart UI)<br>features/containers]
        View[View (Dumb UI)<br>features/widgets]
    end

    subgraph LogicLayer ["Logic Layer"]
        Controller[Controller (Notifier)<br>features/controllers]
    end

    subgraph DataLayer ["Data Layer"]
        Repo[Repository<br>features/infra]
        API[API / BFF]
    end

    User -- Tap/Input --> View
    View -- Callback --> Container
    Page -- builds --> Container
    Container -- calls method --> Controller
    Container -- watches state --> Controller
    Container -- passes Data --> View
    Controller -- calls --> Repo
    Repo -- fetch --> API

```

1. **Container** が `ref.watch` で **Controller** の状態を監視する。
2. 状態が変化したら、データを **View (Widgets)** に渡して描画する。
3. ユーザー操作は **View** からCallback経由で **Container** へ伝わり、**Controller** のメソッドを実行する。

---

## 5. テスト戦略 (Testing Strategy)

### 5.1. Unit & Widget Test (`test/`)

`lib/` ディレクトリと同じ階層構造（ミラーリング）を作成して配置する。CI環境で毎回実行する。

* **`test/features/xxx/controllers/`**: ロジックの単体テスト。Repositoryをモックする。
* **`test/features/xxx/widgets/`**: UI描画テスト。ダミーデータを渡して表示を確認する。
* **`test/features/xxx/containers/`**: 結合テスト。`ProviderScope(overrides: [...])` を使用してControllerをモックに差し替える。

### 5.2. E2E Test (Separate Repository)

ブラックボックステストとして運用するため、別リポジトリで管理する。

* **ツール:** **Maestro** (推奨)
* **タイミング:** リリースビルド作成時、またはStaging環境デプロイ時。
* **構成:** メインリポジトリのArtifacts(APK/IPA)をダウンロードし、外部から操作を実行する。

---

## 6. 自動生成と除外設定

### OpenAPI / Generated Code

* **定義:** プロジェクトルートの `openapi/` に配置。
* **出力:** `lib/infra/generated/` に出力。
* **Lint:** `analysis_options.yaml` にて以下を除外設定する。

```yaml
analyzer:
  exclude:
    - "lib/infra/generated/**"
    - "**/*.g.dart"
    - "**/*.freezed.dart"

```

### 実行コマンド

開発中は以下のコマンドでコード生成を監視する。

```bash
dart run build_runner watch -d

```