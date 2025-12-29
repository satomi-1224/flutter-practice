# データ取得・表示ワークフロー (GET)

サーバーからデータを取得し、画面に表示するまでの実装手順です。
`Product` 一覧を表示するケースを例にします。

---

## 実装ステップ概要

```mermaid
flowchart TD
    Model[1. Model定義<br>(freezed)] --> API[2. API定義<br>(retrofit)]
    API --> Repo[3. Repository実装<br>(Mock/Real)]
    Repo --> Ctrl[4. Controller実装<br>(AsyncNotifier)]
    Ctrl --> UI[5. UI実装<br>(ConsumerWidget)]
```

---

## Step 1. データモデル定義 (Model)

レスポンスのJSON構造に合わせてクラスを定義します。
`fromJson` を定義することで、レスポンスのパースが自動化されます。

**Path**: `lib/features/product/models/product.dart`

```dart
@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required int price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

---

## Step 2. APIクライアント定義 (Retrofit)

通信インターフェースを定義します。`@GET` アノテーションを使用します。

**Path**: `lib/features/product/infra/product_api_client.dart`

```dart
@RestApi()
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  @GET('/products')
  Future<List<Product>> fetchProducts();
}
```

---

## Step 3. リポジトリ実装 (Repository)

APIクライアントをラップし、MockとRealの切り替えを行います。

**Path**: `lib/features/product/infra/product_repository.dart`

```dart
@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  if (Env.useMock) {
    return MockProductRepository();
  } else {
    // Real実装ではAPIクライアントを呼ぶ
    final api = ref.read(productApiClientProvider);
    return ProductRepositoryImpl(api);
  }
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiClient _api;
  ProductRepositoryImpl(this._api);

  @override
  Future<List<Product>> fetchProducts() => _api.fetchProducts();
}
```

---

## Step 4. コントローラー実装 (Controller)

`AsyncNotifier` を使用して、非同期データの取得状態（Loading/Error/Data）を管理します。

**Path**: `lib/features/product/controllers/product_list_controller.dart`

```dart
@riverpod
class ProductListController extends _$ProductListController {
  @override
  FutureOr<List<Product>> build() {
    // Repositoryメソッドを呼ぶだけでOK
    return ref.read(productRepositoryProvider).fetchProducts();
  }
}
```

---

## Step 5. UI実装 (Page/Widget)

`ref.watch` でコントローラーを監視し、`when` メソッドで状態に応じた表示を行います。

**Path**: `lib/pages/product/product_page.dart`

```dart
class ProductPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(productListControllerProvider);

    return Scaffold(
      body: asyncState.when(
        data: (products) => ListView(children: ...),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}
```
