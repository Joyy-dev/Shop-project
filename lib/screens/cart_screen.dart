import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/cart.dart' show Cart;
import 'package:shop_project/provider/order.dart';
import 'package:shop_project/widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = './cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),

      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(9),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                  const Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.yellow
                  ),),
                  backgroundColor: Colors.black,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20),))
                  ),
                  onPressed: () {
                    Provider.of<Order>(context, listen: false).addOrder(
                      cart.items.values.toList(), 
                      cart.totalAmount
                    );
                    cart.clear();
                  }, 
                  child: const Text('Order Now'))
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id, 
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title, 
                cart.items.values.toList()[i].quantity, 
                cart.items.values.toList()[i].price
              )
            )
          )
        ],
      ),
    );
  }
}