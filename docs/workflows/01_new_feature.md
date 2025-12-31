# 01. New Feature Workflow

新機能・新画面を追加する際の標準的な手順です。

## Flow Chart

```mermaid
flowchart TD
    A[1. Make Directories] --> B[2. Define Routes]
    B --> C{Implementation Type}
    C -->|Fetch Data (GET)| D[[02. Data Fetching]]
    C -->|Mutate Data (POST)| E[[03. Data Mutation]]
```

---

## Step 1. ディレクトリ作成 (Scaffolding)

Feature-First アーキテクチャに従い、`lib/features` と `lib/pages` にディレクトリを作成します。

### 例: 注文機能 (Order) を追加する場合

1.  **Feature Directory**: `lib/features/order`
    *   `models`: APIレスポンス定義
    *   `infra`: Repository, API Client
    *   `controllers`: State Management
    *   `widgets`: Dumb UI Components

2.  **Page Directory**: `lib/pages/order`
    *   `order_page.dart`: 画面のエントリーポイント

---

## Step 2. ルーティング定義 (Routing)

`lib/routes/app_router.dart` にパスを追加します。
GoRouterを使用しているため、`routes` 配列に追加します。

```dart
// lib/routes/app_router.dart

GoRoute(
  path: '/orders',
  name: 'orders',
  builder: (context, state) => const OrderPage(),
  routes: [
    // 詳細画面などのネスト
    GoRoute(
      path: ':id',
      name: 'order_detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailPage(orderId: id);
      },
    ),
  ],
),
```

---

## Step 3. 次のステップ

ガワが完成したら、具体的なロジック実装に進みます。

*   **データを表示したい**
    👉 **[02. Data Fetching (GET)](./02_data_fetching.md)**
*   **データを保存・更新したい**
    👉 **[03. Data Mutation (POST)](./03_data_mutation.md)**
