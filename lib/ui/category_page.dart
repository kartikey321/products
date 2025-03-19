import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/helpers/product_helper.dart';
import 'package:products/models/category.dart';
import 'package:products/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _queryController = TextEditingController();
  _filter(String query) {
    List<Product> localFilteredProducts = [];
    if (query.isEmpty) {
      localFilteredProducts = _products;
      setState(() {});
    } else {
      localFilteredProducts = _products
          .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (!listEquals(localFilteredProducts, _filteredProducts)) {
      _filteredProducts = localFilteredProducts;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductHelper()
        .getProductsByCategoryId(widget.category.id, 100, 0)
        .then((val) {
      if (val != null) {
        _products = val;
        _filteredProducts = val;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: _queryController,
            onChanged: _filter,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide())),
          ),
          Expanded(
              child: Consumer<CartProvider>(builder: (context, prov, child) {
            return ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  var item = _filteredProducts[index];
                  bool added = prov.productAdded(item.id);
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    trailing: Column(
                      children: [
                        Text(item.price.formatIndianCurrency()),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            added
                                ? prov.addProduct(item)
                                : prov.removeProduct(item.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Text(added ? 'Add' : 'Remove'),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }))
        ],
      ),
    );
  }
}
