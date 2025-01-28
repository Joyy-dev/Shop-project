import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/order.dart' show Order;
import 'package:shop_project/widget/app_drawer.dart';
import 'package:shop_project/widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Order>(context, listen: false).fetchAndAddOrder();
    });
    if (mounted) {
    setState(() {
      _isLoading = false;
    });
    super.initState();}
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order!'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),

      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(
          orderData.orders[i]
        )),
    );
  }
}