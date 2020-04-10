import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'providers/products_provider.dart';
import './models/cart.dart';
import './models/orders.dart';
import './models/auth.dart';

import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_products_screen.dart';
import 'screens/order_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth,ProductProvider>(
            //create: (ctx)=> ProductProvider(),
            update: (ctx, auth, previousProductProvider) => ProductProvider(
              auth.token,
              previousProductProvider == null? [] : previousProductProvider.items,
              auth.userId,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            //create: (ctx)=> ProductProvider(),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token, auth.userId, previousOrders == null? [] : previousOrders.orders
            ),
          ),
        ],
        child: Consumer<Auth>(builder: (ctx, auth, _) =>MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
//
//          auth.isAuth
//              ? ProductsOverviewScreen()
//              : FutureBuilder(
//                  future: auth.tryAutoLogin(),
//                  builder: (ctx, authResultSnapShot) =>
//                  authResultSnapShot.connectionState == ConnectionState.waiting
//                      ? SplashScreen()
//                      : AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName: (ctx)=> ProductDetailScreen(),
            CartScreen.routeName: (ctx)=> CartScreen(),
            OrdersScreen.routeName: (ctx)=> OrdersScreen(),
            UserProductsScreen.routeName: (ctx)=> UserProductsScreen(),
            EditProductScreen.routeName: (ctx)=> EditProductScreen(),
          },
        ),
        )
    );
  }
}
