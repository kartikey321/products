import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import 'carousel.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.item,
    required this.addedInCart,
  });
  final bool addedInCart;
  final Product item;

  @override
  Widget build(BuildContext context) {
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
                  child: !addedInCart
                      ? InkWell(
                          onTap: () {
                            context.read<CartProvider>().addProduct(item);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            context.read<CartProvider>().removeProduct(item.id);
                          },
                          child: Icon(
                            Icons.remove,
                            color: Colors.red,
                          ),
                        ),
                ),
              ),
              Positioned.fill(
                  child: ImageCarousel(
                      key: ValueKey(item.id), imageUrls: item.images)),
            ],
          )),
          SizedBox(
            height: 7,
          ),
          Text(item.title),
          Text(item.price.formatIndianCurrency())
        ],
      ),
    );
  }
}
