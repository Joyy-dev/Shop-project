import 'package:flutter/material.dart';
import 'package:shop_project/provider/product.dart';

class Products with ChangeNotifier{
  final List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageURL: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageURL: 'https://skit.ng/wp-content/uploads/2020/09/Marcel-Hughes-Young-Men-Trouser-Navy.webp',
      ),
      Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageURL: 'https://assets.aspinaloflondon.com/cdn-cgi/image/fit=pad,format=auto,quality=85,width=650,height=650/images/original/253615-051-2803-309900003.jpg',
      ),
      Product(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageURL: 'https://cdn.shopify.com/s/files/1/0045/7093/9481/products/UKFRYINGPAN11RVT01.jpg?v=1658146754',
      ),
      Product(
        id: 'p5', 
        title: 'Joggers', 
        description: 'Comfortable and cool', 
        price: 39.99, 
        imageURL: 'https://underarmour.scene7.com/is/image/Underarmour/PS1380838-025_HF?rp=standard-0pad|pdpMainDesktop&scl=1&fmt=jpg&qlt=85&resMode=sharp2&cache=on,on&bgc=F0F0F0&wid=566&hei=708&size=566,708'
      ),
      Product(
        id: 'p6', 
        title: 'BackPack', 
        description: 'Easy to carry - what you need for your items', 
        price: 67.09, 
        imageURL: 'https://galaxybags.com.pk/cdn/shop/files/A_5_c6fbf910-bea1-40d0-a7f2-9c59b884123d.jpg?v=1709538087'
      )
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(), 
      title: product.title, 
      description: product.description, 
      price: product.price, 
      imageURL: product.imageURL
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}