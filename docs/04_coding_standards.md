# 04. Coding Standards

本プロジェクトにおけるコーディング規約です。
「なぜそう書くのか」を重視し、可読性と保守性の高いコードを目指します。

## 1. 命名規則 (Naming Conventions)

Dart/Flutterの標準規約準拠に加え、以下のルールを適用します。

### 1.1. ファイル名

*   **Snake Case**: `product_detail_screen.dart`, `product_controller.dart`
*   **Suffix**: 役割を明確にするため、ファイル名の末尾に役割を付けます。

**各層ごとのSuffix**:

| 層 | Suffix | 例 |
|:---|:---|:---|
| **Presentation** | `_screen.dart` | `products_screen.dart` |
| | `_page.dart` | `product_detail_page.dart` |
| | (Widget) | `product_card.dart` |
| **Application** | `_controller.dart` | `product_controller.dart` |
| | `_service.dart` | `payment_service.dart` |
| **Domain** | (モデル名).dart | `product.dart` |
| | `_validation.dart` | `product_validation.dart` |
| **Data** | `_repository.dart` | `product_repository.dart` |
| | `_api_client.dart` | `product_api_client.dart` |

**画面ファイルの命名**:
- `_screen.dart`: 大きな画面単位（例: `products_screen.dart`, `cart_screen.dart`）
- `_page.dart`: 画面内のページや詳細画面（例: `product_detail_page.dart`）

### 1.2. クラス名

*   **Pascal Case**: `ProductDetailScreen`, `ProductController`
*   **Suffix**: ファイル名と一致させます。

```dart
// ✅ Good: ファイル名とクラス名が一致
// products_screen.dart
class ProductsScreen extends ConsumerWidget { ... }

// product_controller.dart
class ProductController extends _$ProductController { ... }
```

### 1.3. 変数・メソッド

*   **Camel Case**: `fetchProductData()`, `isLoading`
*   **Boolean**: `is`, `has`, `can`, `should` で始める。
    *   ✅ `isVisible`, `hasError`, `canSubmit`
    *   ❌ `visible`, `error`, `submit` (形容詞のみは避ける)

### 1.4. プライベート変数

*   アンダースコア `_` で始める: `_apiClient`, `_fetchData()`

---

## 2. ディレクトリとファイルの配置

### 2.1. Feature内の配置ルール

各機能は`lib/src/features/`配下にフォルダを作成し、**4層構造**で整理します。

```text
lib/src/features/products/
  ├── data/                       # データ層
  │   ├── product_repository.dart
  │   ├── product_api_client.dart
  │   └── mock_product_repository.dart
  ├── domain/                     # ドメイン層
  │   ├── product.dart
  │   ├── product.freezed.dart
  │   └── product.g.dart
  ├── application/                # アプリケーション層
  │   └── product_controller.dart
  └── presentation/               # プレゼンテーション層
      ├── products_screen.dart
      ├── product_detail_page.dart
      └── widgets/
          ├── product_card.dart
          └── product_list_tile.dart
```

### 2.2. 共有コードの配置

複数の機能で使用するコードは、以下の場所に配置します。

```text
lib/src/
  ├── common_widgets/             # 共通UIコンポーネント
  │   ├── buttons/
  │   │   ├── primary_button.dart
  │   │   └── secondary_button.dart
  │   └── inputs/
  │       └── custom_text_field.dart
  ├── constants/                  # 定数
  │   ├── app_sizes.dart
  │   └── api_endpoints.dart
  ├── exceptions/                 # 例外クラス
  │   └── app_exception.dart
  └── utils/                      # ユーティリティ
      └── date_formatter.dart
```

**配置基準**:
- **3つ以上の機能**で使用される場合に共有化
- 特定のドメインに依存しない汎用的なコード
- それ以外は各feature内に配置する

---

## 3. コメント規約 (Comments)

**「What（何をしているか）」よりも「Why（なぜそうしているか）」** を記述してください。
コードを見ればわかることはコメント不要です。

### 3.1. 必須コメント

1.  **複雑なロジック**: 一見して意図が掴みにくい計算や条件分岐。
2.  **回避策 (Workaround)**: バグ回避やライブラリの制約による特殊な実装。
3.  **ドメイン知識**: 業務特有のルール。
4.  **非自明な設計判断**: なぜその実装方法を選んだのか。

### 3.2. 良いコメントの例

```dart
// ❌ Bad: コードを見ればわかる
// 商品IDがnullでなければ詳細画面へ遷移
if (productId != null) {
  context.push('/products/$productId');
}

// ✅ Good: なぜその判定が必要なのか、業務ルールを記述
// ゲストユーザーの場合はIDが存在しないため、
// 詳細画面ではなくログイン画面へ誘導する
if (productId != null) {
  context.push('/products/$productId');
} else {
  context.push('/auth/login');
}
```

```dart
// ❌ Bad: 実装内容を繰り返しているだけ
// productListをフィルタリングする
final filteredList = productList.where((p) => p.price > 1000).toList();

// ✅ Good: ビジネスルールを説明
// 高額商品（1,000円以上）のみを表示する仕様
// （プレミアム会員向けフィルタ）
final filteredList = productList.where((p) => p.price > 1000).toList();
```

---

## 4. Widget実装ルール

### 4.1. ConsumerWidget / HookConsumerWidget の使用

状態管理にRiverpodを使用するため、以下のルールに従います：

*   **Riverpodが必要な場合**: `ConsumerWidget` または `HookConsumerWidget`
*   **Riverpodが不要な場合**: `StatelessWidget` または `HookWidget`

```dart
// ✅ Good: Riverpodを使用する場合
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productControllerProvider);
    return Scaffold(...);
  }
}

// ✅ Good: Riverpodを使用しない純粋なUIコンポーネント
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}
```

### 4.2. buildメソッドの肥大化防止

`build` メソッドが長くなりすぎないよう、適切な単位でWidgetを分割してください。

**重要**: メソッド抽出 (`_buildHeader()` など) ではなく、**別クラスのWidgetとして切り出す**ことを推奨します（パフォーマンス最適化のため）。

```dart
// ❌ Bad: メソッドで分割 (リビルド範囲が最適化されない)
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildHeader(),
        _buildBody(),
      ],
    );
  }

  Widget _buildHeader() => AppBar(...);
  Widget _buildBody() => ListView(...);
}

// ✅ Good: クラスで分割 (const化可能でリビルドを抑制)
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        ProductsHeader(),
        ProductsBody(),
      ],
    );
  }
}

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key});
  @override
  Widget build(BuildContext context) => AppBar(...);
}
```

### 4.3. const の積極的な使用

パフォーマンス向上のため、可能な限り `const` を使用します。

```dart
// ✅ Good
const SizedBox(height: 16)
const Text('商品一覧')
const Icon(Icons.shopping_cart)

// ❌ Bad (constを付けられるのに付けていない)
SizedBox(height: 16)
Text('商品一覧')
```

---

## 5. Import整理

### 5.1. Import順序

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. サードパーティパッケージ
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. プロジェクト内（絶対パス推奨）
import 'package:your_app/src/features/products/domain/product.dart';
import 'package:your_app/src/features/products/application/product_controller.dart';
```

### 5.2. 相対パスと絶対パス

**基本方針**: **絶対パス**を推奨（`package:your_app/...`）

**理由**:
- ファイル移動時の影響が少ない
- インポート元が明確
- IDEのサポートが充実

```dart
// ✅ Good: 絶対パス
import 'package:your_app/src/features/products/domain/product.dart';
import 'package:your_app/src/common_widgets/buttons/primary_button.dart';

// ⚠️ 同じfeature内でのみ相対パスも許容
import '../domain/product.dart';
import '../application/product_controller.dart';
```

**`dart fix` コマンド**で自動整列させます：

```bash
dart fix --apply
```

---

## 6. 環境変数 (Environment Variables)

`.env` ファイルへのアクセスは、必ず **`lib/src/config/env.dart`** (Envクラス) を経由してください。

コード内で直接 `dotenv.env['KEY']` を参照することは禁止します。

### 理由
- キー名のタイプミスを防ぐ
- 型安全性の確保
- デフォルト値の管理を一元化

```dart
// ❌ Bad: 直接参照
final apiKey = dotenv.env['API_KEY'];
final useMock = dotenv.env['USE_MOCK'] == 'true';

// ✅ Good: Envクラス経由
final apiKey = Env.apiKey;
final useMock = Env.useMock;
```

**Envクラスの実装例**:

```dart
// lib/src/config/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static bool get useMock => dotenv.env['USE_MOCK'] == 'true';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://api.example.com';
}
```

---

## 7. エラーハンドリング

### 7.1. 例外の分類

アプリケーション全体で統一された例外クラスを使用します。

```dart
// lib/src/exceptions/app_exception.dart
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}
```

### 7.2. Controllerでのエラーハンドリング

```dart
@riverpod
class ProductController extends _$ProductController {
  @override
  Future<List<Product>> build() async {
    try {
      final repository = ref.read(productRepositoryProvider);
      return await repository.fetchProducts();
    } catch (e) {
      // エラーをログに記録し、ユーザーフレンドリーなメッセージを返す
      throw AppException('商品の取得に失敗しました', code: 'FETCH_ERROR');
    }
  }
}
```

---

## 8. その他のベストプラクティス

### 8.1. magic numberの禁止

数値を直接記述せず、定数として定義します。

```dart
// ❌ Bad
Container(height: 16)
await Future.delayed(Duration(milliseconds: 300));

// ✅ Good
Container(height: AppSizes.spacingMedium)
await Future.delayed(AppDurations.animationShort);
```

### 8.2. 状態管理のベストプラクティス

- **Read/Watch の使い分け**:
  - `ref.watch`: ウィジェットのリビルドが必要な場合
  - `ref.read`: イベントハンドラ内での一度きりの読み取り

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // ✅ build内ではwatch（状態変化を監視）
  final products = ref.watch(productControllerProvider);

  return ElevatedButton(
    // ✅ イベントハンドラ内ではread（一度きりの実行）
    onPressed: () => ref.read(productControllerProvider.notifier).refresh(),
    child: const Text('更新'),
  );
}
```

### 8.3. Freezedの活用

ドメインモデルは必ず`Freezed`を使用してイミュータブルにします。

```dart
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String title,
    required double price,
    String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

---

## 9. まとめ

コーディング規約を守ることで：

1. **一貫性**: チーム全員が同じスタイルでコードを書ける
2. **可読性**: コードが読みやすく、理解しやすい
3. **保守性**: バグの修正や機能追加が容易
4. **パフォーマンス**: 不要なリビルドを防ぎ、アプリの性能を向上

**疑問がある場合は、このドキュメントを更新してチームで合意を形成しましょう。**
