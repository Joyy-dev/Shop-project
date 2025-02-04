import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_project/provider/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier{
  List<Product> _items = [
    /*Product(
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
      )*/
  ];

  final String? authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);
  
  

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct ([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    
    url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    final favoriteResponse = await http.get(Uri.parse(url));
    final favoriteData = json.decode(favoriteResponse.body);
    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId, 
        title: prodData['title'], 
        description: prodData['description'], 
        price: prodData['price'], 
        imageURL: prodData['imageURL'],
        isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false
      ));
    }); 
    _items = loadedProducts;
    notifyListeners();
  } catch (error) {
    print('error');
    rethrow;
  }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/products.json?autha=$authToken';
    try {
    final response = await http.post(
      Uri.parse(url), 
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageURL': product.imageURL,
        'creatorId': userId
      }
    )
  );
    final responseData = json.decode(response.body);
    final newProduct = Product(
      id: responseData['name'], 
      title: product.title, 
      description: product.description, 
      price: product.price, 
      imageURL: product.imageURL
    );
    _items.add(newProduct);
    notifyListeners();
  } catch (error) {
    print('error');
    rethrow;
  }}

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    http.patch(
      Uri.parse(url),
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageURL': newProduct.imageURL
      })
    );
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    } else{
      print('Product not found');
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product ? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Failed to delete product.');
    }
    existingProduct = null;   
  }
}