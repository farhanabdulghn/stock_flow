import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/states/stores/product/product_notifier.dart';

part 'product_state.g.dart';

@riverpod
Future<List<ProductModel>> getProducts(Ref ref) async {
  return ref.watch(productProvider);
}
