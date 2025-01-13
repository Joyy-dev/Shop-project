import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/products.dart';
import 'package:shop_project/widget/product_items.dart';

class product_grid extends StatelessWidget {
  final bool showFav;

  product_grid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final product = showFav ? productData.favoriteItems : productData.items;
    return GridView.builder(
      itemCount: product.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 20
      ), 
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: product[index],
        child: ProductItems()
      )
      );
  }
}