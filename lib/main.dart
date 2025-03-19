import 'package:flutter/material.dart';
import 'package:products/dataProviders/cart_provider.dart';
import 'package:products/ui/cart_screen.dart';
import 'package:products/ui/category_page.dart';
import 'package:products/ui/home_screen.dart';
import 'package:products/ui/product_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: HomeScreen.screenName,
        onGenerateRoute: (settings) {
          return switch (settings.name) {
            CartScreen.screenName => MaterialPageRoute(
                builder: (BuildContext context) => CartScreen()),
            CategoryPage.screenName => MaterialPageRoute(
                builder: (BuildContext context) => CategoryPage(
                    category: (settings.arguments
                        as Map<String, dynamic>)['category'])),
            HomeScreen.screenName => MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()),
            ProductPage.screenName => MaterialPageRoute(
                builder: (BuildContext context) => ProductPage(
                    product: (settings.arguments
                        as Map<String, dynamic>)['product'])),
            _ => null
          };
        },
      ),
    );
  }
}
