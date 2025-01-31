import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/auth.dart';
import 'package:shop_project/provider/cart.dart';
import 'package:shop_project/provider/order.dart';
import 'package:shop_project/provider/product.dart';
import 'package:shop_project/provider/products.dart';
import 'package:shop_project/screens/auth_screen.dart';
import 'package:shop_project/screens/cart_screen.dart';
import 'package:shop_project/screens/edit_products.dart';
import 'package:shop_project/screens/order_screen.dart';
import 'package:shop_project/screens/product_details_sreen.dart';
import 'package:shop_project/screens/product_overview_screen.dart';
import 'package:shop_project/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth()
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', []), 
          update: (context, auth, previousProducts) => Products(
            auth.token, 
            previousProducts?.items.cast<Product>() ?? []
          ),
        ),
        /*ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', []),
          update: (context, auth, previousProducts) => Products(
            auth.token, 
            previousProducts?.items == null ?? <Product>[]
          )
        ),*/
        ChangeNotifierProvider(
          create: (context) => Cart()
        ),
        ChangeNotifierProvider(
          create: (context) => Order()
        )
      ],
      child: Consumer<Auth>(builder: (context, auth, _) => MaterialApp(
        title: 'My Shop',
        home: auth.isAuth ? const ProductOverviewScreen() : const AuthScreen(),
        routes: {
          ProductOverviewScreen.routeName: (context) => const ProductOverviewScreen(),
          ProductDetailsSreen.routeName: (context) => ProductDetailsSreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProductScreen.routeName: (context) => const UserProductScreen(),
          EditProducts.routeName: (context) => const EditProducts(),
        },
      ),
      )
    );
  }
}
