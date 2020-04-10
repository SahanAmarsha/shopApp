import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem
{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this. amount,
    @required this.products,
    @required this.dateTime});

}

class Orders with ChangeNotifier
{

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders= [];

  List<OrderItem> get orders
  {
    return[..._orders];
  }

  Future<void> fetchAndSetOrders() async
  {
    final url = 'https://flutter-project1-c23eb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null)
      {
        return;
      }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
          OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>).map(
                  (item) => CartItem
                    (
                      id: item['id'],
                      title: item['title'],
                      qty: item['qunatity'],
                      price: item['price'],
                  )
              ).toList(),
              dateTime: DateTime.parse(orderData['dateTime'])
          )
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();

  }

  Future<void> addOrder( List<CartItem> cartProducts, double total) async
  {
    final  url =  'https://flutter-project1-c23eb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try{

      final timeStamp = DateTime.now();
      final response = await http.post(url, body: json.encode({
        'amount' : total,
        'dateTime' : timeStamp.toIso8601String(),
        'products' : cartProducts.map((cp) =>{
          'id' : cp.id,
          'title' : cp.title,
          'quantity' : cp.qty,
          'price' : cp.price,
        }).toList(),

      })
      );
      _orders.insert(0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()
          ));
      notifyListeners();
    } catch (error)
    {
      print(error);
      throw(error);
    }

  }


}