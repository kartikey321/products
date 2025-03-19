import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/utils/extensions.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String screenName = '/cart-screen';
  const CartScreen({super.key});
  _pay(double price) {
    Fluttertoast.showToast(
        msg:
            "user has paid ${price.formatIndianCurrency()} and order has been placed");
  }

  final double _deliveryCharges = 20.0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Consumer<CartProvider>(builder: (context, prov, child) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                ),
                child: Column(
                  children: [
                    Text('Items'),
                    Expanded(
                        child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        var item = prov.products[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(item.images[0]),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(item.title),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(item.price.formatIndianCurrency()),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all()),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        prov.removeProduct(item.id);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      },
                      itemCount: prov.products.length,
                    ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text('Bill'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  displayKeyVal(MapEntry('Item Total',
                      prov.calculatePrice().formatIndianCurrency())),
                  displayKeyVal(MapEntry('Delivery Partner Fee',
                      _deliveryCharges.formatIndianCurrency()))
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  _pay(prov.calculatePrice() + _deliveryCharges);
                },
                child: Center(
                  child: Text('Pay'),
                ))
          ],
        );
      }),
    );
  }

  Widget displayKeyVal(MapEntry<String, String> entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(entry.key), Text(entry.value)],
      ),
    );
  }
}
