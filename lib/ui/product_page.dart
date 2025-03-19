import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/helpers/product_helper.dart';
import 'package:products/ui/widgets/carousel.dart';
import 'package:products/ui/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductPage extends StatefulWidget {
  static const String screenName = '/product-screen';

  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>?> _similarProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _similarProducts = ProductHelper().getRelatedProducts(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.product.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white24),
            child: Column(
              children: [
                SizedBox(
                    height: 150,
                    child: ImageCarousel(imageUrls: widget.product.images)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(widget.product.category.name),
                      ],
                    ),
                    Consumer<CartProvider>(builder: (context, prov, child) {
                      bool added = prov.productAdded(widget.product.id);
                      return InkWell(
                        onTap: () {
                          added
                              ? prov.addProduct(widget.product)
                              : prov.removeProduct(widget.product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(added ? 'Add' : 'Remove'),
                        ),
                      );
                    })
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text('Similar Products'),
          FutureBuilder(
              future: _similarProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer<CartProvider>(
                      builder: (context, prov, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return ProductItem(
                              item: item,
                              addedInCart: prov.productAdded(item.id));
                        });
                  });
                }
                return CircularProgressIndicator();
              })
        ],
      ),
    );
  }
}
