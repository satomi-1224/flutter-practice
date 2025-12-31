// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ListingController)
final listingControllerProvider = ListingControllerProvider._();

final class ListingControllerProvider
    extends $AsyncNotifierProvider<ListingController, void> {
  ListingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listingControllerHash();

  @$internal
  @override
  ListingController create() => ListingController();
}

String _$listingControllerHash() => r'1e13591cd8ac27d20891bcb0fced8333f6a22a22';

abstract class _$ListingController extends $AsyncNotifier<void> {
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
