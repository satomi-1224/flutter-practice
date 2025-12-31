# 05. State Management (Riverpod)

本プロジェクトでは、状態管理に **Riverpod (Generator)** を採用しています。
従来の `StateNotifierProvider` 等の手動定義は避け、アノテーション (`@riverpod`) を用いた自動生成を利用します。

## 1. Providerの定義

### 1.1. 通常のProvider (Sync)
同期的な値を保持する場合、または単純なロジックのみを持つ場合に使用します。

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_controller.g.dart';

@riverpod
class CounterController extends _$CounterController {
  @override
  int build() {
    // 初期値を返す
    return 0;
  }

  void increment() {
    // state を更新するとUIが再描画される
    state++;
  }
}
```

### 1.2. 非同期Provider (Async)
API通信など、非同期処理を伴う状態管理には `FutureOr<T>` を返します。
これにより、自動的に `AsyncValue<T>` 型として扱われ、Loading/Error状態を管理できます。

```dart
@riverpod
class ProductListController extends _$ProductListController {
  @override
  FutureOr<List<Product>> build() async {
    // Repositoryからデータを取得
    return ref.read(productRepositoryProvider).fetchProducts();
  }

  // データの再取得（Pull to Refreshなど）
  Future<void> refresh() async {
    // stateをloadingに戻してから再実行
    state = const AsyncLoading();
    // build()を再実行して新しい値をセット
    state = await AsyncValue.guard(() => build());
  }
}
```

---

## 2. UIでの利用 (Consumption)

`ConsumerWidget` または `HookConsumerWidget` を使用し、`ref.watch` で監視します。

### AsyncValueのハンドリング
非同期データは `.when()` メソッドを使って、3つの状態（Data, Loading, Error）を必ずハンドリングします。

```dart
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue<List<Product>>
    final asyncProducts = ref.watch(productListControllerProvider);

    return Scaffold(
      body: asyncProducts.when(
        // ✅ データ取得成功
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ProductTile(product: products[index]),
        ),
        
        // ⏳ ロード中
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 🚨 エラー発生
        error: (error, stackTrace) {
          // エラーログ出力等の副作用はここではなく、listenで行うのが推奨だが
          // 単純な表示ならここでOK
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
```

---

## 3. ベストプラクティス

### 3.1. invalidateSelf
データ更新後など、強制的にデータを再取得したい場合は `ref.invalidateSelf()` を使用します。

### 3.2. KeepAlive
画面遷移しても状態を保持したい（キャッシュしたい）場合は、`@Riverpod(keepAlive: true)` を付与します。

```dart
// 画面を抜けても破棄されない
@Riverpod(keepAlive: true)
class UserSession extends _$UserSession { ... }
```

### 3.3. 副作用 (Side Effects)
スナックバーの表示や画面遷移などの副作用は、`build` メソッド内ではなく、イベントハンドラ（ボタン押下時）や `ref.listen` 内で行います。

```dart
// ❌ Bad: build内で直接実行 (リビルドのたびに走る)
if (state.hasError) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}

// ✅ Good: listenを使用
ref.listen(myProvider, (previous, next) {
  if (next is AsyncError) {
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
});
```
