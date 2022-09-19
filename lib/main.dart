import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/providers.dart';
import './ui/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewPage(),
        routes: {
          ProductDetailPage.routeName: (context) => ProductDetailPage(),
          CartPage.routeName: (context) => CartPage(),
          OrderPage.routeName: (context) => OrderPage(),
          UserProductPage.routeName: (context) => UserProductPage(),
          EditProductPage.routeName: (context) => EditProductPage(),
        },
      ),
    );
  }
}
