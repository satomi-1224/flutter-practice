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
* **Configuration:** flutter_dotenv

---

## 2. ディレクトリ構成 (Directory Structure)

トップレベルと機能モジュール内部で構成を統一する「フラクタル構造」を採用しています。

```text
lib/
├── config/              # 環境変数 (Env), 定数
│   └── env.dart         # 環境変数アクセサ
│
├── pages/               # 【画面カタログ】 (Routing Endpoints)
│   ├── auth/
│   │   └── login/
│   │       └── login_page.dart  # /auth/login
│   ├── product/
│   │   ├── product_page.dart    # /products
│   │   └── detail/
│   │       └── product_detail_page.dart # /products/:id
│   └── cart/
│       └── cart_page.dart       # /cart
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
* **命名・構造ルール:**
    *   **1パス = 1ディレクトリ**: URLのパスセグメントごとにディレクトリを切る。
    *   **1ディレクトリ = 1ファイル**: 各ディレクトリにはメインとなるPageファイルを1つ配置する。
    *   **単数形**: ディレクトリ名・ファイル名は原則として単数形を使用する（例: `products/list` ではなく `product/product_page.dart`）。
    *   **ネスト**: 下層ページはサブディレクトリとしてネストする（例: `/products/:id` → `product/detail/product_detail_page.dart`）。

### 3.2. Features (`lib/features/`)

機能ごとの「縦割り」モジュール。原則として他機能の内部実装（Controller/Repository）に依存してはならない。

*   **命名ルール**: ディレクトリ名は**単数形**で統一する（例: `products` ではなく `product`）。

| ディレクトリ | 役割 | 詳細 |
| --- | --- | --- |
| **`infra`** | Data Layer | APIクライアント(Retrofit)とRepositoryの実装。Mock/Realの切り替えもここで行う。 |
| **`models`** | Data Model | BFFからのレスポンス定義。EntityとDTOを兼ねる。 |
| **`controllers`** | Logic | `Notifier` / `AsyncNotifier` による状態管理とビジネスロジック。 |
| **`containers`** | **Smart UI** | Controller(`ref`)とWidgetを繋ぐ結合層。データを取得し、Viewに渡す。 |
| **`widgets`** | **Dumb UI** | ロジックを持たない純粋な表示部品。Atomic Designで構成。 |

### 3.3. Config (`lib/config/`)

環境ごとの設定値を管理する。

*   **`.env`**: APIキーやベースURLなどを定義（Git管理対象外）。
*   **`env.dart`**: `flutter_dotenv` をラップし、型安全に環境変数へアクセスするためのクラス。コード内では直接 `dotenv` を呼ばず、必ずこのクラスを経由する。

---

## 4. データフロー & Mock戦略

### 4.1. データフロー (MVVM)

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

### 4.2. Mock戦略

開発効率向上のため、環境変数によって実APIとMockを切り替えられるようにする。

1.  **`.env` 設定**: `USE_MOCK=true` を定義。
2.  **Repository実装**: `Provider` 内でフラグを判定し、`MockRepository` か `RealRepository` を返す。

```dart
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (Env.useMock) {
    return MockAuthRepository();
  } else {
    return AuthRepositoryImpl();
  }
}
```

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

### Build Runner (Freezed, Riverpod, etc.)

*   **配置**: 生成ファイル（`.g.dart`, `.freezed.dart`）は、**元のソースファイルの隣**に配置する。
*   **理由**: `part` 宣言によるプライベートメンバへのアクセスが必要なため。
*   **Lint除外**: `analysis_options.yaml` にて警告対象外に設定する。

### 実行コマンド

開発中は以下のコマンドでコード生成を監視する。

```bash
dart run build_runner watch -d
```