import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/products.dart';

class ProductDetailsSreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        title: Text(loadedProducts.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Image.network(loadedProducts.imageURL, fit: BoxFit.cover,),
            ),
            const SizedBox(height: 10,),
            Text(
              '\$${loadedProducts.price}', 
              style: const TextStyle(
              fontSize: 17, 
              color: Colors.grey
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              loadedProducts.description, 
              style: const TextStyle(
                 fontSize: 20,
                ),
               textAlign: TextAlign.center, 
               softWrap: true
              ),
          )
          ],
        ),
      ),
    );
  }
}