import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/helpers/categories_helper.dart';
import 'package:products/helpers/product_helper.dart';
import 'package:products/models/product.dart';
import 'package:products/ui/widgets/carousel.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> _products = [];
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
        _products.addAll(val);
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
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: (5 / 7)),
                  itemBuilder: (context, index) {
                    var item = _products[index];
                    return Container(
                      height: 140,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                  child: ImageCarousel(
                                      key: ValueKey(item.id),
                                      imageUrls: item.images)),
                            ],
                          )),
                          SizedBox(
                            height: 7,
                          ),
                          Text(item.title)
                        ],
                      ),
                    );
                  });
            })
          ],
        ),
      ),
    );
  }
}
