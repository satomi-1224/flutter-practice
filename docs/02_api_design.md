# 02. API Design Guidelines (BFF)

本ドキュメントでは、Flutterアプリ (Frontend) と BFF (Backend For Frontend / Laravel) 間におけるAPI設計の標準方針を定めます。

## 1. 基本哲学: UI-Driven API

BFFの最大の目的は、**クライアントサイド（Flutter）のロジックを最小化し、UI描画に最適化されたデータを返すこと**です。

### ✅ 推奨される設計 (DO)
*   **Aggregate (集約)**: 1画面に必要な情報は、可能な限り1回のリクエストでまとめて返す。
*   **Formatted (加工済み)**: 日付フォーマット(`2024/01/01`)、通貨記号(`¥1,000`)、結合文字列(`田中 太郎`)などはBFF側で加工して返す。
*   **Logical Flags (論理フラグ)**: `status_id = 1` ではなく、`is_editable: true` のようにUIが判断すべきフラグを返す。

### 🚫 避けるべき設計 (DON'T)
*   **Raw Data**: DBのカラム（`created_at`, 内部IDなど）をそのまま返さない。
*   **Client-Side Calculation**: 合計金額の計算や、複数のAPIレスポンスの結合（Merge）をFlutter側で行わせない。
*   **Magic Numbers**: `status: 1` のような数値を返し、Flutter側で `if (status == 1)` と判定させない。

---

## 2. 命名規則 (Naming Convention)

*   **Case**: JSONのキーは **snake_case** (スネークケース) で統一する。
    *   Flutter側では `json_serializable` が自動的に `camelCase` にマッピングします。
*   **Boolean**: `is_`, `has_`, `can_`, `should_` などの接頭辞を付ける。
    *   例: `is_published`, `has_error`, `can_edit`

---

## 3. エンドポイント設計 (Endpoint Design)

RESTful（リソース指向）よりも **「UIのユースケース（画面・操作）」に即した設計** を優先します。

### 3.1. 画面単位のエンドポイント (Screen Oriented)
クライアントは「1画面1リクエスト」で描画を開始できるようにします。

*   **`GET /screens/home`**
    *   ホーム画面用データ一式 (バナー、新着商品、ニュースなど)
*   **`GET /screens/products/{id}`**
    *   商品詳細画面用 (商品情報、関連商品、レビュー要約)
*   **`GET /screens/mypage`**
    *   マイページ用 (ユーザー情報、注文履歴要約、お気に入り数)

### 3.2. ユースケース単位のアクション (Purpose Oriented)
CRUDではなく、ユーザーの「意図」を表す命名にします。

*   ❌ `PUT /orders/{id}` (更新範囲が不明瞭)
*   ✅ `POST /orders/{id}/cancel` (注文キャンセル)
*   ✅ `POST /checkout` (購入確定)

---

## 4. レスポンス形式 (Response Format)

### 4.1. Widget-Oriented Structure
レスポンスのルートキーは、画面内の主要なWidget（セクション）に対応させます。

```json
// GET /screens/home
{
  // HeroSectionWidget 用
  "hero_banner": {
    "image_url": "https://example.com/banner.jpg",
    "title": "Summer Sale",
    "action_url": "/campaigns/summer"
  },
  
  // ProductCarouselWidget 用
  "new_arrivals": [
    { "id": 1, "title": "T-Shirt A", "price_label": "¥3,000" },
    { "id": 2, "title": "Cap B", "price_label": "¥2,500" }
  ]
}
```

### 4.2. 具体例: 商品詳細 (Before / After)

#### ❌ Bad: Raw Data
DB構造が露出しており、Flutter側で「価格フォーマット」「在庫判定」「カテゴリ解決」などのロジックが必要になる。

```json
{
  "id": 123,
  "title": "T-Shirt",
  "price": 1000,
  "category_id": 5,
  "stock_count": 0,
  "status": 1
}
```

#### ✅ Good: BFF Optimized
UIに必要な情報が揃っており、Flutterは表示するだけで済む。

```json
{
  "id": 123,
  "title": "T-Shirt",
  "display_price": "¥1,000",      // UI表示用フォーマット済み
  "category": {                   // IDではなくネームを返す、またはオブジェクト化
    "id": 5,
    "name": "Apparel"
  },
  "is_out_of_stock": true,        // 在庫判定済みフラグ (stock_count == 0)
  "badge_label": "New Arrival"    // UIに表示すべきバッジがあれば返す
}
```

---

## 5. エラーハンドリング (Error Handling)

HTTPステータスコードを適切に使用し、エラー詳細はJSONで返します。

| Status | Meaning | Usage |
| :--- | :--- | :--- |
| **200** | OK | 成功 |
| **400** | Bad Request | リクエストパラメータ不備 |
| **401** | Unauthorized | 未認証 (トークン切れ) |
| **403** | Forbidden | 権限なし |
| **404** | Not Found | リソースなし |
| **422** | Unprocessable Entity | バリデーションエラー |
| **500** | Server Error | サーバー内部エラー |

### バリデーションエラー例 (422)

```json
{
  "code": "validation_error",
  "message": "入力内容に誤りがあります。",
  "errors": {
    "email": ["メールアドレスの形式が正しくありません。"],
    "password": ["パスワードは8文字以上で入力してください。"]
  }
}
```
