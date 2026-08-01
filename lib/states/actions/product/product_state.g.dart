// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getGuests)
final getGuestsProvider = GetGuestsProvider._();

final class GetGuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          FutureOr<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $FutureProvider<List<ProductModel>> {
  GetGuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getGuestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getGuestsHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductModel>> create(Ref ref) {
    return getGuests(ref);
  }
}

String _$getGuestsHash() => r'7996f711dd81d0031c301a037e4da4a83782b5f3';
