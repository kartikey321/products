import 'dart:convert';

import 'package:products/helpers/request_helper.dart';
import 'package:products/models/product.dart';

class ProductHelper {
  final RequestHelper _requestHelper = RequestHelper();
  Future<List<Product>?> getProducts(int limit, int offset) async {
    try {
      var categoriesJson = await _requestHelper.getRequest(
          'https://api.escuelajs.co/api/v1/products?limit=$limit&offset=$offset');
      var catMap = jsonDecode(categoriesJson);
      return (catMap as List).map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Product>?> getRelatedProducts(int productId) async {
    try {
      var categoriesJson = await _requestHelper.getRequest(
          'https://api.escuelajs.co/api/v1/products/$productId/related');
      var catMap = jsonDecode(categoriesJson);
      return (catMap as List).map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Product?> getSingleProduct(int id) async {
    try {
      var categoriesJson = await _requestHelper
          .getRequest('https://api.escuelajs.co/api/v1/products/$id');
      var catMap = jsonDecode(categoriesJson);
      return Product.fromMap(catMap);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
