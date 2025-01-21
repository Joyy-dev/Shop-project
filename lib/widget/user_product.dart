import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/products.dart';
import 'package:shop_project/screens/edit_products.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  const UserProduct(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(backgroundImage: NetworkImage(imageURL),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProducts.routeName, arguments: id);
                }, 
                icon: const Icon(Icons.edit, color: Colors.black,),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false).deleteProduct(id);
                }, 
                icon: const Icon(Icons.delete, color: Colors.red,)
              )
            ],
          ),      
        ),
      ),
    );
  }
}