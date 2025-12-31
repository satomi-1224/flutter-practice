# BFF API 設計方針 (Guidelines)

本ドキュメントでは、Flutterアプリ (Frontend) と BFF (Laravel) 間におけるAPI設計の標準方針を定めます。

## 1. 基本哲学: UI-Driven API

BFF (Backend For Frontend) の最大の目的は、**クライアントサイド（Flutter）のロジックを最小化し、UI描画に最適化されたデータを返すこと**です。

### ✅ 推奨される設計 (DO)
*   **UI構造に合わせたレスポンス**: 画面に必要な情報は、可能な限り1回のリクエストでまとめて返す（Aggregate）。
*   **フォーマット済みデータ**: 日付フォーマット、通貨記号、結合文字列などはBFF側で加工して返す。
*   **論理フラグ**: `status_id = 1` ではなく、`is_editable: true` のようにUIが判断すべきフラグを返す。

### 🚫 避けるべき設計 (DON'T)
*   **DB構造のそのままの露呈**: 不要なカラム（`created_at`, `updated_at`, 内部IDなど）をそのまま返さない。
*   **クライアント側での複雑な計算**: 合計金額の計算や、複数のAPIレスポンスの結合（Merge）をFlutter側で行わせない。
*   **マジックナンバー**: `status: 1` のような数値を返し、Flutter側で `if (status == 1)` と判定させない。

---

## 2. 命名規則 (Naming Convention)

*   **ケース**: JSONのキーは **snake_case** (スネークケース) で統一する。
    *   例: `user_id`, `total_amount`, `is_active`
    *   理由: Laravel (PHP) の標準であり、Flutter側では `json_serializable` が自動的に camelCase に変換するため。
*   **Boolean**: `is_`, `has_`, `can_` などの接頭辞を付ける。
    *   例: `is_published`, `has_error`

---

## 3. エンドポイント設計 (Endpoint Design)

BFFにおいては、純粋なRESTful（リソース指向）よりも **「UIのユースケース（画面・操作）」に即した設計** を優先します。

### 3.1. 画面単位のエンドポイント (Screen/Page Oriented)
特定の画面を表示するために必要なデータを集約したエンドポイント設計を推奨します。
これにより、クライアントは「1画面1リクエスト」で描画を開始できます。

*   **命名例**:
    *   `GET /screens/home` (ホーム画面用データ一式)
    *   `GET /screens/product-detail/{id}` (商品詳細画面用: 商品情報 + 関連商品 + レビュー要約など)
    *   `GET /screens/mypage` (マイページ用: ユーザー情報 + 最新の注文履歴 + お気に入り数)

### 3.2. ユースケース単位のアクション (Purpose Oriented)
CRUD（作成・更新・削除）という抽象的な操作ではなく、ユーザーの具体的な「意図」を表す命名にします。

*   **命名例**:
    *   ❌ `PUT /orders/{id}` (単なる更新？何が変わる？)
    *   ✅ `POST /orders/{id}/cancel` (注文キャンセル)
    *   ✅ `POST /checkout` (購入確定処理)
    *   ✅ `POST /auth/login` (ログイン)

### 3.3. 汎用リソースとの使い分け
マスタデータや単純な一覧取得など、特定の画面に依存しないデータについては、`/common`以下とし従来のRESTfulな命名（リソース名 + 複数形）を使用しても構いません。

*   `GET /common/categories` (カテゴリ一覧)
*   `GET /common/prefectures` (都道府県一覧)

---

## 4. レスポンス形式 (Response Format: Widget-Oriented)

Flutterの **Widget (コンポーネント) 単位** でデータを構造化することを推奨します。
画面全体のレスポンスは、それらWidget用データの集合体（Aggregate）として定義します。

### 4.1. 基本構造 (Screen Response)
ルートレベルのキーは、画面内の主要なWidget（セクション）に対応させます。

```json
// GET /screens/home
{
  // HeroSectionWidget に渡すデータ
  "hero_banner": {
    "image_url": "https://example.com/banner.jpg",
    "title": "Summer Sale",
    "action_url": "/campaigns/summer"
  },
  
  // ProductCarouselWidget に渡すデータリスト
  "new_arrivals": [
    { "id": 1, "title": "T-Shirt A", "price_label": "¥3,000" },
    { "id": 2, "title": "Cap B", "price_label": "¥2,500" }
  ],
  
  // NewsListWidget に渡すデータリスト
  "latest_news": [
    { "id": 101, "date": "2024.01.01", "headline": "New Year Sale" }
  ]
}
```

### 4.2. メリット
*   **Front-Endとの対応**: Flutter側で `HeroSection(data: response.heroBanner)` のように、レスポンスの一部をそのままWidgetに渡す実装が容易になります。
*   **再利用性**: 複数の画面で同じWidgetを使う場合、APIレスポンスの構造も統一しておけば、Widgetとデータ型をそのまま再利用できます。

---

## 5. データ型とNull安全性

Flutterの型安全性(Null Safety)を守るため、API定義は厳格に行います。

*   **Boolean**: 0/1 ではなく、必ず `true` / `false` を返す。
*   **List**: データがない場合は `null` ではなく `[]` (空配列) を返す。
*   **Nullable**: 値が存在しない可能性がある場合は `null` を明示的に返す（キー自体を省略しない）。

---

## 5. エラーハンドリング

HTTPステータスコードを適切に使用し、エラー詳細はJSONで返します。

| Status | 意味 | 用途 |
| :--- | :--- | :--- |
| **200** | OK | 成功 |
| **400** | Bad Request | リクエストパラメータ不備 |
| **401** | Unauthorized | 未認証 (トークン切れ) |
| **403** | Forbidden | 権限なし |
| **404** | Not Found | リソースなし |
| **422** | Unprocessable Entity | バリデーションエラー |
| **500** | Internal Server Error | サーバー内部エラー |

### エラーレスポンス例
```json
{
  "code": "validation_error",
  "message": "入力内容に誤りがあります。",
  "errors": {
    "email": ["メールアドレスの形式が正しくありません。"]
  }
}
```

---

## 6. 具体例: 商品詳細画面 (Product Detail)

### ❌ 悪い例 (Raw Data)
DBのカラムをそのまま返しているため、Flutter側でカテゴリIDの解決や価格フォーマット、在庫判定ロジックが必要になる。

```json
// GET /api/products/123
{
  "id": 123,
  "title": "T-Shirt",
  "price": 1000,
  "category_id": 5,
  "stock_count": 0,
  "status": 1
}
```

### ✅ 良い例 (BFF Optimized)
UI表示に必要な情報が揃っており、Flutterは表示するだけで済む。

```json
// GET /api/products/123
{
  "id": 123,
  "title": "T-Shirt",
  "price": 1000,
  "display_price": "¥1,000",      // UI表示用フォーマット済み
  "category": {                   // 関連データはネストして返す
    "id": 5,
    "name": "Apparel"
  },
  "is_out_of_stock": true,        // 在庫切れかどうかの判定済みフラグ
  "badge_label": "New Arrival"    // UIに表示すべきバッジがあれば返す
}
```
