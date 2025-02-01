import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_project/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    required this.id, 
    required this.amount, 
    required this.products, 
    required this.dateTime
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;

  Order (this.authToken, this._orders);

  List<OrderItem> get orders {
    return[..._orders];
  }

  Future<void> fetchAndAddOrder() async {
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null || extractedData.isEmpty) {
        _orders = [];
        notifyListeners();
        return;
      }

      final List<OrderItem> loadedOrder = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrder.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>).map((item) => 
            CartItem(
              id: item['id'], 
              title: item['title'], 
              quantity: item['quantity'], 
              price: item['price']
            )).toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          )
        );
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching orders');
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async{
    final url = 'https://shop-app-3e5ac-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url), 
        body: json.encode({
          'amount': total,
          'products': cartProduct.map((cartProduct) => {
            'id': cartProduct.id,
            'title': cartProduct.title,
            'quantity': cartProduct.quantity,
            'price': cartProduct.price
          }).toList(),
          'dateTime': DateTime.now().toIso8601String(),
        })
      );
      _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: DateTime.now(),
      ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void clearCart() {
    _orders = [];
    notifyListeners();
  }
}
