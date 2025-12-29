// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_create_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderCreateController)
final orderCreateControllerProvider = OrderCreateControllerProvider._();

final class OrderCreateControllerProvider
    extends $AsyncNotifierProvider<OrderCreateController, void> {
  OrderCreateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderCreateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderCreateControllerHash();

  @$internal
  @override
  OrderCreateController create() => OrderCreateController();
}

String _$orderCreateControllerHash() =>
    r'22764f9c35b0b2b02251c732d48a895793a39f6a';

abstract class _$OrderCreateController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
