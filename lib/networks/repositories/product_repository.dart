import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:untitled/gen/assets.gen.dart';
import 'package:untitled/models/product/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    final String jsonString = await rootBundle.loadString(
      Assets.dummy.products,
    );

    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }
}
