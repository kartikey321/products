import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/helpers/categories_helper.dart';
import 'package:products/helpers/product_helper.dart';
import 'package:products/models/product.dart';
import 'package:products/ui/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<List<Product>> _products = ValueNotifier([]);
  late Future<List<Category>?> getCategories;
  // late Future<List<Product>?> getProducts;
  final int _categoriesLimit = 10;
  late ScrollController scrollController;
  int _productOffset = 0;
  late int _productBatchesCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories = CategoriesHelper().getCategories(_categoriesLimit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >=
            0.9 * scrollController.position.maxScrollExtent - 150) {
          setProducts();
        }
      });
  }

  setProducts() {
    _productOffset += _productBatchesCount;
    ProductHelper()
        .getProducts(_productBatchesCount, _productOffset)
        .then((val) {
      if (val != null) {
        _products.value += val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Categories'),
            SizedBox(
              height: 150,
              child: FutureBuilder(
                  future: getCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data![index];
                            return Container(
                              height: 140,
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: Image.network(item.image)),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(item.name)
                                ],
                              ),
                            );
                          });
                    }
                    return CircularProgressIndicator();
                  }),
            ),
            Consumer<CartProvider>(builder: (context, prov, child) {
              return ValueListenableBuilder(
                  valueListenable: _products,
                  builder: (context, products, child) {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: (5 / 7)),
                        itemBuilder: (context, index) {
                          var item = products[index];

                          return ProductItem(
                            item: item,
                            addedInCart: prov.productAdded(item.id),
                          );
                        });
                  });
            })
          ],
        ),
      ),
    );
  }
}
