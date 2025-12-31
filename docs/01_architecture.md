# 01. Architecture & Directory Structure

## 1. 概要 (Overview)

本プロジェクトは、**Feature-First (機能単位)** のディレクトリ構成を採用したFlutterアプリケーションです。
バックエンドに **BFF (Backend For Frontend / Laravel)** が存在することを前提とし、クライアントサイドでの複雑なデータ変換を避け、UI構築と状態管理に注力する **MVVM + Atomic Design** アーキテクチャを採用しています。

### 技術スタック (Tech Stack)

| Category | Tech | Description |
| :--- | :--- | :--- |
| **Framework** | Flutter | クロスプラットフォームUIフレームワーク |
| **State Mngt** | Riverpod | `Notifier` / `AsyncNotifier` (Generator使用推奨) |
| **Routing** | GoRouter | URLベースの宣言的ルーティング |
| **HTTP Client** | Dio + Retrofit | 型安全なAPIクライアント |
| **Data Class** | Freezed | イミュータブルなデータモデル |
| **UI Pattern** | Atomic Design | UIコンポーネントの再利用性を高める設計 |

---

## 2. ディレクトリ構成 (Directory Structure)

トップレベルと機能モジュール内部で構成を統一する「フラクタル構造」を採用しています。
機能追加時は `lib/features/` 以下にディレクトリを切り、その中で MVC (MVVM) を完結させます。

```text
lib/
├── config/              # 環境変数 (Env), 定数
│   └── env.dart         # 環境変数アクセサ
│
├── pages/               # 【画面カタログ】 (Routing Endpoints)
│   │                    # URLと1対1で対応する画面のルートWidget
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
│   │                    # ドメインごとのロジックとUI部品
│   ├── auth/
│   └── products/
│       ├── infra/       # Data Layer: API通信・Repository実装
│       ├── models/      # Data Layer: Data Model (BFFレスポンス / Freezed)
│       ├── controllers/ # Logic Layer: State Management (Riverpod Notifier)
│       ├── containers/  # Smart UI: ControllerとWidgetを繋ぐ結合層
│       └── widgets/     # Dumb UI: ロジックを持たない純粋な表示部品
│
├── widgets/             # 【汎用UI】 (Atomic Design / Shared)
│   │                    # 特定のfeatureに依存しない再利用可能な部品
│   ├── atoms/           # ボタン, アイコン, テキスト
│   ├── molecules/       # リストタイル, フォーム入力
│   └── layouts/         # 共通レイアウト枠 (Scaffold wrapper)
│
├── infra/               # 【全域基盤】 (Infrastructures)
│   ├── api/             # Dio設定, Interceptors
│   └── exceptions/      # 共通例外定義
│
├── routes/              # ルーティング定義 (GoRouter)
├── theme/               # デザイン定義 (ThemeData, Colors)
├── utils/               # ヘルパー関数 (Extensions, Formatters)
├── app.dart             # MaterialApp
└── main.dart            # Entry Point
```

---

## 3. 各層の役割 (Layer Responsibilities)

### 3.1. Pages (`lib/pages/`)

*   **役割**: ルーティングの終端（URLと対になるファイル）。`Scaffold` を持ち、画面全体の構成を定義します。
*   **ルール**:
    *   **ロジックを持たない**: データの取得や状態管理は `features/containers` または `features/controllers` に委譲します。
    *   **命名**: URLパスに基づいたディレクトリ構造にします。

### 3.2. Features (`lib/features/`)

機能ごとの「縦割り」モジュールです。原則として、あるFeatureが別のFeatureの内部実装（Repositoryなど）を直接参照することは避けます（Controller経由などで疎結合に保つ）。

| ディレクトリ | 層 | 役割・詳細 |
| :--- | :--- | :--- |
| **`infra`** | Data | **APIクライアント(Retrofit)とRepositoryの実装**。<br>Mock/Realの切り替えロジックもここに記述します。 |
| **`models`** | Data | **データモデル**。<br>BFFからのレスポンス定義。Freezedを用いてイミュータブルにします。 |
| **`controllers`** | Logic | **ビジネスロジックと状態管理**。<br>`Notifier` / `AsyncNotifier` を用いてUIに必要な状態を提供します。 |
| **`containers`** | UI (Smart) | **ControllerとViewの接着剤**。<br>`ref.watch` でデータを監視し、適切な `widgets` (Dumb UI) にデータを渡します。 |
| **`widgets`** | UI (Dumb) | **純粋なUI部品**。<br>Riverpod (`ref`) に依存せず、引数で渡されたデータのみを表示します。テスト容易性が高いです。 |

---

## 4. データフロー (Data Flow)

MVVMパターンに基づき、データは一方向に流れます。

```mermaid
graph TD
    User((User))
    
    subgraph ViewLayer ["View Layer (UI)"]
        Page[Page<br>(lib/pages)]
        Container[Container<br>(Smart UI)]
        View[Widget<br>(Dumb UI)]
    end

    subgraph LogicLayer ["Logic Layer (ViewModel)"]
        Controller[Controller<br>(Notifier)]
    end

    subgraph DataLayer ["Data Layer (Model)"]
        Repo[Repository]
        API[API / BFF]
    end

    User -- 1. Action (Tap) --> View
    View -- 2. Callback --> Container
    Page -- builds --> Container
    Container -- 3. Calls Method --> Controller
    Container -- 4. Watches State --> Controller
    Container -- 5. Passes Data --> View
    Controller -- 6. Request --> Repo
    Repo -- 7. Fetch --> API
```

### 実装例: データフロー

```dart
// [Dumb UI] 純粋な表示コンポーネント
// 外部依存(Riverpod等)を持たず、受け取ったデータ(title)を表示するのみ。
class ProductTitle extends StatelessWidget {
  final String title;
  const ProductTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

// [Smart UI / Container] ロジックとUIの結合
// Riverpod(ref)を使ってデータを取得し、Dumb UIに渡す。
class ProductContainer extends ConsumerWidget {
  const ProductContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllerの状態を監視 (Loading/Error/Data)
    final asyncValue = ref.watch(productDetailControllerProvider);

    return asyncValue.when(
      // データ取得成功時: Dumb UIにデータを渡して描画
      data: (product) => ProductTitle(title: product.title),
      // ロード中
      loading: () => const CircularProgressIndicator(),
      // エラー時
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

---

## 5. Mock戦略 (Development Strategy)

開発効率向上のため、環境変数によって実APIとMockを切り替えられる設計にします。

1.  **`.env` 設定**: `USE_MOCK=true` を定義。
2.  **Repository実装**: `Provider` 内でフラグを判定し、`MockRepository` か `RealRepository` を返します。

```dart
// lib/features/product/infra/product_repository.dart

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  // 環境変数 USE_MOCK をチェック
  // 開発初期やオフライン時でも開発を進められるようにする
  if (Env.useMock) {
    return MockProductRepository();
  } else {
    // 実実装: APIクライアント(Dio)を使用
    final api = ref.read(productApiClientProvider);
    return ProductRepositoryImpl(api);
  }
}
```

---

## 6. テスト戦略 (Testing)

### 6.1. Unit & Widget Test (`test/`)
CI環境で毎回実行します。

*   **Controller Test**: RepositoryをMockし、状態遷移(Loading -> Data / Error)を検証。
*   **Widget Test**: Dumb UIに対してダミーデータを渡し、意図通りの描画が行われるか検証。

### 6.2. E2E Test (Maestro)
別リポジトリで管理・運用します（推奨）。
アプリのビルド成果物(APK/IPA)に対してブラックボックステストを行います。
