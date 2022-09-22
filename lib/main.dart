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
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider('', '', []),
          update: (ctx, auth, previousProductProvider) => ProductProvider(
              auth.token,
              auth.userId,
              previousProductProvider == null
                  ? []
                  : previousProductProvider.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: (ctx) => OrderProvider([], '', ''),
            update: (ctx, auth, previousOrderProvider) => OrderProvider(
                previousOrderProvider == null
                    ? []
                    : previousOrderProvider.orders,
                auth.userId,
                auth.token)),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverviewPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthPage(),
                ),
          routes: {
            ProductDetailPage.routeName: (context) => ProductDetailPage(),
            CartPage.routeName: (context) => CartPage(),
            OrderPage.routeName: (context) => OrderPage(),
            UserProductPage.routeName: (context) => UserProductPage(),
            EditProductPage.routeName: (context) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
