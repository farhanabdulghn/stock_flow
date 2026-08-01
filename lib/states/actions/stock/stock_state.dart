import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/stock/stock_model.dart';
import 'package:untitled/states/actions/product/product_state.dart';
import 'package:untitled/states/stores/transaction_product_inbound/transaction_product_inbound_notifier.dart';
import 'package:untitled/states/stores/transaction_product_outbound/transaction_product_outbound_notifier.dart';

part 'stock_state.g.dart';

String _normalizeSku(String value) {
  return value.trim().toUpperCase();
}

@riverpod
Future<List<StockModel>> stockList(Ref ref) async {
  final products = await ref.watch(getProductsProvider.future);

  final inboundTransactions = ref.watch(transactionProductInboundProvider);

  final outboundTransactions = ref.watch(transactionProductOutboundProvider);

  final totalInBySku = <String, int>{};

  for (final transaction in inboundTransactions) {
    final sku = _normalizeSku(transaction.product);

    totalInBySku.update(
      sku,
      (currentQuantity) {
        return currentQuantity + transaction.quantity;
      },
      ifAbsent: () {
        return transaction.quantity;
      },
    );
  }

  final totalOutBySku = <String, int>{};

  for (final transaction in outboundTransactions) {
    final sku = _normalizeSku(transaction.product);

    totalOutBySku.update(
      sku,
      (currentQuantity) {
        return currentQuantity + transaction.quantity;
      },
      ifAbsent: () {
        return transaction.quantity;
      },
    );
  }

  return products.map((product) {
    final sku = _normalizeSku(product.sku);

    return StockModel(
      sku: product.sku,
      itemName: product.itemName,
      category: product.category,
      unit: product.unit,
      totalIn: totalInBySku[sku] ?? 0,
      totalOut: totalOutBySku[sku] ?? 0,
    );
  }).toList();
}

@riverpod
Future<int> stockQuantityBySku(Ref ref, String sku) async {
  final stocks = await ref.watch(stockListProvider.future);
  final normalizedSku = _normalizeSku(sku);

  for (final stock in stocks) {
    if (_normalizeSku(stock.sku) == normalizedSku) {
      return stock.quantity;
    }
  }

  return 0;
}
