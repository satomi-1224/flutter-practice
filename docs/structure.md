# Sample App Implementation Plan: Flutter Shop

アーキテクチャとライブラリ活用を実証するための、5ページ構成のECデモアプリ開発計画です。
MVVM + Atomic Design + Feature-First 構成を採用します。

## 1. アプリ概要

*   **名称**: Flutter Shop
*   **コンセプト**: シンプルなECアプリ
*   **ページ構成 (5 screens)**:
    1.  **Login Page**: 認証・ログインフォーム (`/auth/login`)
    2.  **Product List Page**: 商品一覧 (Home) (`/products`)
    3.  **Product Detail Page**: 商品詳細 (`/products/:id`)
    4.  **Cart Page**: カート確認・合計金額 (`/cart`)
    5.  **Settings Page**: テーマ設定・ログアウト (`/settings`)

## 2. 実装ステップ

### Phase 1: 基盤実装 (Infrastructure)
*   [ ] **Theme**: アプリ全体のデザインシステム定義 (`lib/theme`).
*   [ ] **Network**: `Dio` クライアント設定と `http_mock_adapter` によるMockサーバー構築 (`lib/infra/api`).
*   [ ] **Routing**: `GoRouter` の基本設定とTyped Routes定義 (`lib/routes`).
*   [ ] **Utils**: 金額フォーマッターなど (`lib/utils`).

### Phase 2: 共通コンポーネント (Shared Widgets)
Atomic Designに基づく汎用パーツの実装 (`lib/widgets`).
*   [ ] **Atoms**: ボタン (PrimaryButton), テキスト入力 (InputField), アイコン.
*   [ ] **Layouts**: 共通Scaffold (AppBar, BottomNavigationBarを含む).

### Phase 3: 認証機能 (Feature: Auth)
*   [ ] **Models**: `User` (`freezed`).
*   [ ] **Infra**: `AuthRepository` (Retrofit interface + Mock).
*   [ ] **Controllers**: `AuthController` (ログイン状態管理, `flutter_secure_storage`連携).
*   [ ] **UI**: `LoginPage` (コンテナ + `flutter_hooks` 使用のフォーム).

### Phase 4: 商品機能 (Feature: Products)
*   [ ] **Models**: `Product` (`freezed`).
*   [ ] **Infra**: `ProductRepository`.
*   [ ] **Controllers**: `ProductListController`, `ProductDetailProvider`.
*   [ ] **UI**: `ProductListPage` (無限スクロール想定 or シンプルリスト), `ProductDetailPage`.

### Phase 5: カート機能 (Feature: Cart)
*   [ ] **Models**: `CartItem`.
*   [ ] **Controllers**: `CartController` (ローカルState管理, 追加/削除/計算).
*   [ ] **UI**: `CartPage` (リスト表示 + 合計金額バー).

### Phase 6: 設定機能 & 仕上げ (Feature: Settings)
*   [ ] **Controllers**: `ThemeController` (`shared_preferences` 連携).
*   [ ] **UI**: `SettingsPage` (ダークモード切替, ログアウトボタン).
*   [ ] **Main**: `main.dart` エントリーポイントの整備.

## 3. データモデル設計 (簡易)

### User
```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    required String token,
  }) = _User;
}
```

### Product
```dart
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required String description,
    required double price,
    required String imageUrl,
  }) = _Product;
}
```

## 4. アーキテクチャ適用ポイント

*   **Feature-First**: `lib/features/auth`, `lib/features/products` など機能ごとに分割。
*   **MVVM**:
    *   **Model**: Freezedクラス, Repository.
    *   **ViewModel**: Riverpod Notifier / AsyncNotifier.
    *   **View**: Widgets (Dumb UI) + Containers (Smart UI).
*   **DI**: Riverpodですべての依存関係（Repository, Dioなど）を注入。
*   **Routing**: `GoRouter` + `TypedGoRoute` で型安全な遷移。

## 5. 開発コマンド

```bash
# コード生成の監視
dart run build_runner watch -d
```
