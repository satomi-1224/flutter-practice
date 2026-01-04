# 02. Data Fetching Workflow (GET)

サーバーからデータを取得し、画面に表示するまでの実装手順です。
`Product`（商品）一覧を取得・表示するケースを例に解説します。

---

## Step 1. Data Model (Freezed)

APIレスポンスのJSON構造に合わせてモデルを定義します。
`lib/features/product/models/product.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  // APIレスポンスのフィールド定義
  // JSONのキーはsnake_caseだが、Dart側はcamelCaseで定義する。
  // @JsonKeyなどは build_runner が自動解決する設定になっているため基本不要。
  const factory Product({
    required int id,
    required String title,
    // 値がnullで返る可能性がある場合はnullableにする
    required String? description,
    required int price,
  }) = _Product;

  // JSONからインスタンスを生成するためのファクトリ
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

---

## Step 2. API Client (Retrofit)

Dioを使った通信インターフェースを定義します。
`lib/features/product/infra/product_api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/product.dart';

part 'product_api_client.g.dart';

@RestApi()
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  // GETリクエストの定義
  // エンドポイントのパスを指定する
  @GET('/products')
  Future<List<Product>> fetchProducts();
}
```

---

## Step 3. Repository

APIクライアントを隠蔽し、アプリ内でのデータ取得の窓口となります。
Mockへの切り替えもここで行います。
`lib/features/product/infra/product_repository.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'product_api_client.dart';
import '../models/product.dart';

part 'product_repository.g.dart';

// RepositoryのProvider定義
// keepAlive: true にすることで、キャッシュとして振る舞わせることも可能だが
// 基本は呼び出し元(Controller)で管理するため false(デフォルト) でよい。
@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  // 環境変数等でMock判定を行う場合はここで分岐
  // if (Env.useMock) return MockProductRepository();
  
  // Real実装: API ClientのProviderを取得して注入
  final api = ref.read(productApiClientProvider);
  return ProductRepositoryImpl(api);
}

// 抽象クラス定義
abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
}

// 実装クラス
class ProductRepositoryImpl implements ProductRepository {
  final ProductApiClient _api;
  ProductRepositoryImpl(this._api);

  @override
  Future<List<Product>> fetchProducts() async {
    // 必要であればここで例外の変換や、データの加工を行う
    // 例: API独自の例外をドメイン例外に変換するなど
    return _api.fetchProducts();
  }
}
```

---

## Step 4. Controller (AsyncNotifier)

UIの状態（Loading / Data / Error）を管理します。
`lib/features/product/controllers/product_list_controller.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../infra/product_repository.dart';

part 'product_list_controller.g.dart';

@riverpod
class ProductListController extends _$ProductListController {
  
  // buildメソッドが初期化時に呼ばれ、この戻り値が state (AsyncValue) となる
  @override
  FutureOr<List<Product>> build() async {
    // Repository経由でデータを取得
    // awaitすることで、完了するまで state は AsyncLoading となる
    return ref.read(productRepositoryProvider).fetchProducts();
  }

  // 手動リフレッシュ用メソッド
  Future<void> refresh() async {
    // stateを強制的にローディング状態にする
    state = const AsyncLoading();
    
    // build() を再実行し、結果をstateに反映する
    // AsyncValue.guard で囲むことで、例外発生時に AsyncError に変換してくれる
    state = await AsyncValue.guard(() => build());
  }
}
```

---

## Step 5. UI Implementation

`lib/pages/product/product_list_page.dart`

```dart
class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllerの状態を監視
    // データが更新されると自動的にリビルドされる
    final asyncProducts = ref.watch(productListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      // AsyncValue.when で3つの状態を網羅的にハンドリングする
      body: asyncProducts.when(
        // ✅ データ取得成功時
        data: (products) {
          // データが空の場合の表示
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          // リスト表示
          return RefreshIndicator(
            // スワイプで更新: Controllerのrefreshメソッドを呼ぶ
            onRefresh: () => ref.read(productListControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('¥${product.price}'),
                );
              },
            ),
          );
        },
        
        // 🚨 エラー発生時
        error: (error, stackTrace) {
          // エラー内容を表示し、リトライボタンを置くなどの対応
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () {
                    // 再試行: Providerを再生成(invalidate)する
                    ref.invalidate(productListControllerProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        
        // ⏳ ロード中
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
```
