import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/auth.dart';
import 'package:shop_project/provider/cart.dart';
import 'package:shop_project/provider/product.dart';
import 'package:shop_project/screens/product_details_sreen.dart';

class ProductItems extends StatelessWidget {
  /*final String id;
  final String title;
  final String imageURL;

  const ProductItems(this.id, this.title, this.imageURL, {super.key});*/

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),

      child: GridTile(
        footer:GridTileBar(
          backgroundColor: Colors.black,
          title: Text(product.title,
          style: const TextStyle(
            fontSize: 18
          ),textAlign: TextAlign.center,),
          leading: Consumer<Product>(builder: (context, product, _) => IconButton(
              onPressed: () {
                product.toggleIsFavorite(authData.token, authData.userId);
              } , 
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border), 
              color: Colors.yellow,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(
                product.id, 
                product.price, 
                product.title
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Items Added To Cart!',),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO', 
                    onPressed: () {
                      cart.removeItem(product.id);
                    }
                  ),
                )
              );
            }, 
            icon: const Icon(
              Icons.shopping_cart, 
              color: Colors.yellow,
            )
          )
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context, 
              ProductDetailsSreen.routeName,
              arguments: product.id
            );
          },
          child: Image.network(
            product.imageURL, 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}