import 'package:flutter/material.dart';
import 'package:shop_project/screens/order_screen.dart';
import 'package:shop_project/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:  [
          AppBar(
            title: const Text('Hello Friends!'), 
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            foregroundColor: Colors.yellow,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Manage Products'),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          const Divider()
        ],
      ),
    );
  }
}