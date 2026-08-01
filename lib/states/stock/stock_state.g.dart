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

String _$stockListHash() => r'31fcd6e704de514ce402c9d57a951cd4b0328301';

/// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
/// (validasi stok saat barang keluar).

@ProviderFor(stockQuantityByItemName)
final stockQuantityByItemNameProvider = StockQuantityByItemNameFamily._();

/// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
/// (validasi stok saat barang keluar).

final class StockQuantityByItemNameProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
  /// (validasi stok saat barang keluar).
  StockQuantityByItemNameProvider._({
    required StockQuantityByItemNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stockQuantityByItemNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockQuantityByItemNameHash();

  @override
  String toString() {
    return r'stockQuantityByItemNameProvider'
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
    return stockQuantityByItemName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StockQuantityByItemNameProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockQuantityByItemNameHash() =>
    r'a4797e73176dbf18ccf01c24c74d94caa478e2e7';

/// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
/// (validasi stok saat barang keluar).

final class StockQuantityByItemNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  StockQuantityByItemNameFamily._()
    : super(
        retry: null,
        name: r'stockQuantityByItemNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
  /// (validasi stok saat barang keluar).

  StockQuantityByItemNameProvider call(String itemName) =>
      StockQuantityByItemNameProvider._(argument: itemName, from: this);

  @override
  String toString() => r'stockQuantityByItemNameProvider';
}
