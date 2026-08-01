// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockList)
final stockListProvider = StockListProvider._();

final class StockListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StockModel>>,
          List<StockModel>,
          FutureOr<List<StockModel>>
        >
    with $FutureModifier<List<StockModel>>, $FutureProvider<List<StockModel>> {
  StockListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockListHash();

  @$internal
  @override
  $FutureProviderElement<List<StockModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StockModel>> create(Ref ref) {
    return stockList(ref);
  }
}

String _$stockListHash() => r'2a2b1d66b25293540c48f1a74f9fd633f0f4a146';

@ProviderFor(stockQuantityBySku)
final stockQuantityBySkuProvider = StockQuantityBySkuFamily._();

final class StockQuantityBySkuProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  StockQuantityBySkuProvider._({
    required StockQuantityBySkuFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stockQuantityBySkuProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockQuantityBySkuHash();

  @override
  String toString() {
    return r'stockQuantityBySkuProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return stockQuantityBySku(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StockQuantityBySkuProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockQuantityBySkuHash() =>
    r'94c7c7e1a13fe22d1d9387a97590644fa95ea091';

final class StockQuantityBySkuFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  StockQuantityBySkuFamily._()
    : super(
        retry: null,
        name: r'stockQuantityBySkuProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StockQuantityBySkuProvider call(String sku) =>
      StockQuantityBySkuProvider._(argument: sku, from: this);

  @override
  String toString() => r'stockQuantityBySkuProvider';
}
