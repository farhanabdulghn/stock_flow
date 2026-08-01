import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/stock/stock_model.dart';
import 'package:untitled/states/actions/product/product_state.dart';
import 'package:untitled/states/stores/transaction_product_inbound/transaction_product_inbound_notifier.dart';
import 'package:untitled/states/stores/transaction_product_outbound/transaction_product_outbound_notifier.dart';

part 'stock_state.g.dart';

@riverpod
Future<List<StockModel>> stockList(Ref ref) async {
  final products = await ref.watch(getProductsProvider.future);
  final inboundTransactions = ref.watch(transactionProductInboundProvider);
  final outboundTransactions = ref.watch(transactionProductOutboundProvider);

  final totalInByProduct = <String, int>{};
  for (final transaction in inboundTransactions) {
    totalInByProduct.update(
      transaction.product,
      (value) => value + transaction.quantity,
      ifAbsent: () => transaction.quantity,
    );
  }

  final totalOutByProduct = <String, int>{};
  for (final transaction in outboundTransactions) {
    totalOutByProduct.update(
      transaction.product,
      (value) => value + transaction.quantity,
      ifAbsent: () => transaction.quantity,
    );
  }

  return products.map((product) {
    return StockModel(
      sku: product.sku,
      itemName: product.itemName,
      category: product.category,
      unit: product.unit,
      totalIn: totalInByProduct[product.itemName] ?? 0,
      totalOut: totalOutByProduct[product.itemName] ?? 0,
    );
  }).toList();
}

/// Helper untuk ambil stok satu barang saja, dipakai nanti di step 4
/// (validasi stok saat barang keluar).
@riverpod
Future<int> stockQuantityByItemName(Ref ref, String itemName) async {
  final list = await ref.watch(stockListProvider.future);

  for (final stock in list) {
    if (stock.itemName == itemName) return stock.quantity;
  }

  return 0;
}
