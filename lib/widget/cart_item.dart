import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItem(this.id, this.productId, this.title, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.black,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 5
        ),
        child: const Icon(Icons.delete, color: Colors.yellow,),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
     },
     confirmDismiss: (direction) {
      return showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to remove items from cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              }, 
              child: const Text('No'),
            ), 
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              }, 
              child: const Text('Yes'))
          ],
        ));
     },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 9, 
            vertical: 5), 
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.yellow,
                child: FittedBox(
                  child: Text('\$$price')
                ),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${price * quantity}'),
              trailing: Text('x$quantity',
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}