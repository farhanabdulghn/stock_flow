import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/product/product_model.dart';
import 'package:untitled/networks/repositories/product_repository.dart';

part 'product_state.g.dart';

@riverpod
Future<List<ProductModel>> getProducts(Ref ref) {
  return ProductRepository().getProducts();
}
