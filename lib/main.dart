import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/cart.dart';
import 'package:shop_project/provider/order.dart';
import 'package:shop_project/provider/products.dart';
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
          create: (context) => Products()
        ),
        ChangeNotifierProvider(
          create: (context) => Cart()
        ),
        ChangeNotifierProvider(
          create: (context) => Order()
        )
      ],
      child: MaterialApp(
        title: 'My Shop',
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailsSreen.routeName: (context) => ProductDetailsSreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProductScreen.routeName: (context) => const UserProductScreen(),
          EditProducts.routeName: (context) => const EditProducts(),
        },
      ),
    );
  }
}
