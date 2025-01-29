import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/provider/cart.dart';
import 'package:shop_project/provider/products.dart';
import 'package:shop_project/screens/cart_screen.dart';
import 'package:shop_project/widget/app_drawer.dart';
import 'package:shop_project/widget/product_grid.dart';

enum FilterOptions {
  favorite,
  all,
}
class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchAndSetProduct(). then((_) {
        setState(() {
          _isLoading = false;
        });
      }); 
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showOnlyFavorite = true;
                } else {
                  _showOnlyFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All')
              )
            ],
            icon: const Icon(Icons.more_vert,),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => 
            Badge(
              child: ch,
              label: Text(cart.itemCount.toString()),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }, 
              icon: const Icon(Icons.shopping_cart)
            ),
          ),
        ],
      ),

      drawer: const AppDrawer(),
      body: _isLoading ? 
      const Center(
        child: CircularProgressIndicator(),
      ) 
      : product_grid(_showOnlyFavorite),
    );
  }
}