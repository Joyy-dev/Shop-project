import 'package:flutter/material.dart';
import 'package:shop_project/screens/edit_products.dart';

class UserProduct extends StatelessWidget {
  final String title;
  final String imageURL;

  const UserProduct(this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Row(
        children: [
          IconButton(onPressed: () {Navigator.of(context).pushNamed(EditProducts.routeName);}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}