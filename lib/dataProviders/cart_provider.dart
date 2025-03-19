import 'package:flutter/cupertino.dart';
import 'package:products/models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _products = [];
  addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  bool productAdded(int id) {
    return _products.indexWhere((e) => e.id == id) != -1;
  }

  List<Product> get products => _products;

  removeProduct(int id) {
    var index = _products.indexWhere((e) => e.id == id);
    if (index != -1) {
      _products.removeAt(index);
      notifyListeners();
    }
  }

  calculatePrice() {}
}
