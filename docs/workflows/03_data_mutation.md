# 03. Data Mutation Workflow (POST/PUT)

サーバーへデータを送信し、作成・更新を行う際の実装手順です。
`Product`（商品）を新規作成するケースを例にします。

---

## Step 1. Request Model

送信するデータの構造を定義します。
GET時のモデル(`Product`)を流用できる場合もありますが、作成時のみ必要なフィールドや不要なフィールド（IDなど）がある場合は、別途Requestモデルを作成することを推奨します。

`lib/features/product/models/create_product_request.dart`

```dart
@freezed
class CreateProductRequest with _$CreateProductRequest {
  const factory CreateProductRequest({
    required String title,
    required int price,
    // 作成時はID不要などの差分があるため、専用クラス定義が安全
  }) = _CreateProductRequest;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) => 
      _$CreateProductRequestFromJson(json);
}
```

---

## Step 2. API Client (Retrofit)

`@POST`, `@PUT` 等のメソッドを定義します。

`lib/features/product/infra/product_api_client.dart`

```dart
@RestApi()
abstract class ProductApiClient {
  // ... (GET定義など)

  // POSTリクエスト
  // @Body() を付けると、引数のオブジェクトが toJson() されてBodyにセットされる
  @POST('/products')
  Future<void> createProduct(@Body() CreateProductRequest request);
}
```

---

## Step 3. Repository

`lib/features/product/infra/product_repository.dart`

```dart
abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  // 作成用メソッド追加
  Future<void> createProduct(CreateProductRequest request);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiClient _api;
  ProductRepositoryImpl(this._api);

  // ...

  @override
  Future<void> createProduct(CreateProductRequest request) async {
    // API呼び出し
    await _api.createProduct(request);
  }
}
```

---

## Step 4. Controller (Action Method)

データの更新メソッドを定義します。
更新成功後に、一覧データ(`build`メソッドで取得しているデータ)を最新化するために `invalidateSelf` を呼ぶパターンが一般的です。

`lib/features/product/controllers/product_list_controller.dart`

```dart
@riverpod
class ProductListController extends _$ProductListController {
  @override
  FutureOr<List<Product>> build() {
    return ref.read(productRepositoryProvider).fetchProducts();
  }

  // 商品追加アクション
  Future<void> addProduct({required String title, required int price}) async {
    // 1. リクエストモデル作成
    final request = CreateProductRequest(title: title, price: price);
    final repo = ref.read(productRepositoryProvider);

    // 2. ローディング状態にする（Option）
    // UI側でローディング表示を出すために、stateをLoadingにする場合がある
    // ただし、画面全体をローディングにするのではなく、ダイアログ等で制御する場合は不要
    state = const AsyncLoading();

    // 3. API実行
    // AsyncValue.guard で例外ハンドリングを行う
    state = await AsyncValue.guard(() async {
      await repo.createProduct(request);
      
      // 4. 成功した場合、自身のキャッシュを破棄して再取得(build)を走らせる
      // これにより、追加された商品を含む最新リストが表示される
      ref.invalidateSelf();
      
      // 再取得完了まで待つ（こうすることでUIはData状態で戻ってくる）
      return build(); 
    });
  }
}
```

---

## Step 5. UI Implementation (Event Trigger)

ボタン押下時などにControllerのメソッドを呼び出します。
処理結果（成功/失敗）に応じた副作用（画面遷移、スナックバー）は、`await` の後、または `ref.listen` で行います。

`lib/pages/product/product_add_page.dart`

```dart
class ProductAddPage extends HookConsumerWidget {
  const ProductAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 入力フォーム用コントローラ (flutter_hooks)
    final titleController = useTextEditingController();
    final priceController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price')),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () async {
                // バリデーション等のチェック
                if (titleController.text.isEmpty) return;

                try {
                  // Controllerのメソッド呼び出し
                  await ref.read(productListControllerProvider.notifier).addProduct(
                    title: titleController.text,
                    price: int.parse(priceController.text),
                  );

                  // 成功時の処理
                  if (context.mounted) {
                    context.pop(); // 画面を閉じる
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Created successfully!')),
                    );
                  }
                } catch (e) {
                  // Controller内で AsyncValue.guard している場合、
                  // state.error に入るためここでのcatchは必須ではないが、
                  // 個別にエラー表示したい場合はここで拾うか、ref.listenを使う
                  if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed: $e')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
```
