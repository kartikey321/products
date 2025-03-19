import 'dart:convert';

import 'package:products/helpers/request_helper.dart';

import '../models/category.dart';

class CategoriesHelper {
  final RequestHelper _requestHelper = RequestHelper();
  Future<List<Category>?> getCategories(int limit) async {
    try {
      var categoriesJson = await _requestHelper.getRequest(
          'https://api.escuelajs.co/api/v1/categories?limit=$limit');
      var catMap = jsonDecode(categoriesJson);
      return (catMap as List).map((e) => Category.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Category?> getSingleCategory(String id) async {
    try {
      var categoriesJson = await _requestHelper
          .getRequest('https://api.escuelajs.co/api/v1/categories/$id');
      var catMap = jsonDecode(categoriesJson);
      return Category.fromMap(catMap);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
