import 'package:flutter/material.dart';
import 'package:products/helpers/categories_helper.dart';
import 'package:products/helpers/product_helper.dart';
import 'package:products/models/product.dart';

import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>?> getCategories;
  late Future<List<Product>?> getProducts;
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
            0.9 * scrollController.position.maxScrollExtent-150) {
          _productOffset += _productBatchesCount;
          setProducts();
        }
      });
  }

  setProducts() {
    getProducts =
        ProductHelper().getProducts(_productBatchesCount, _productOffset);
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
            FutureBuilder(future: getProducts, builder: (context,snapshot){
              if(snapshot.hasData){

                return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context,index){
                  var item = snapshot.data![index];
                  return Container(
                    height: 140,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: Image.network(item.)),
                        SizedBox(
                          height: 7,
                        ),
                        Text(item.name)
                      ],
                    ),
                  );
                });
              }

            });
          ],
        ),
      ),
    );
  }
}
