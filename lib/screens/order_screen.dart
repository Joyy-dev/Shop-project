import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/order.dart' show Order;
import 'package:shop_project/widget/app_drawer.dart';
import 'package:shop_project/widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),

      drawer: const AppDrawer(),

      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndAddOrder(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(child: Text('An error occurred!'),);
            } else {
              return Consumer<Order>(builder: (context, orderData, child) => ListView.builder(
               itemCount: orderData.orders.length,
               itemBuilder: (ctx, i) => OrderItem(
               orderData.orders[i]
              ))); 
            }
          }
        }  
      ) 
    );
  }
}