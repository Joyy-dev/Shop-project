import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/products.dart';
import 'package:shop_project/screens/edit_products.dart';
import 'package:shop_project/widget/app_drawer.dart';
import 'package:shop_project/widget/user_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducts.routeName);
            }, 
            icon: const Icon(Icons.add)
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting 
          ? const Center(child: CircularProgressIndicator(),) 
          : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (context, productData, _) => 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProduct(
                        productData.items[i].id,
                        productData.items[i].title,
                        productData.items[i].imageURL
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      )
      );
    }
  }