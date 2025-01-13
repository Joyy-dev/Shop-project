import 'package:flutter/material.dart';

class UserProduct extends StatelessWidget {
  final String title;
  final String imageURL;

  const UserProduct(this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageURL),),
    );
  }
}