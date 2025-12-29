// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderListController)
final orderListControllerProvider = OrderListControllerProvider._();

final class OrderListControllerProvider
    extends $AsyncNotifierProvider<OrderListController, List<Order>> {
  OrderListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderListControllerHash();

  @$internal
  @override
  OrderListController create() => OrderListController();
}

String _$orderListControllerHash() =>
    r'e42077336a37a29b4db65adc4c7cb382001bf72f';

abstract class _$OrderListController extends $AsyncNotifier<List<Order>> {
  FutureOr<List<Order>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Order>>, List<Order>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Order>>, List<Order>>,
              AsyncValue<List<Order>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(orderDetail)
final orderDetailProvider = OrderDetailFamily._();

final class OrderDetailProvider
    extends $FunctionalProvider<AsyncValue<Order>, Order, FutureOr<Order>>
    with $FutureModifier<Order>, $FutureProvider<Order> {
  OrderDetailProvider._({
    required OrderDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailHash();

  @override
  String toString() {
    return r'orderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Order> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Order> create(Ref ref) {
    final argument = this.argument as int;
    return orderDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailHash() => r'105236e8089899c486bcc0aa5cb19ba9d0f008c1';

final class OrderDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Order>, int> {
  OrderDetailFamily._()
    : super(
        retry: null,
        name: r'orderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailProvider call(int id) =>
      OrderDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'orderDetailProvider';
}
