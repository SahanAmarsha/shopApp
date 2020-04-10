import 'package:flutter/material.dart';

class CartItem
{
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.qty,
    @required this.price
  });
}

class Cart with ChangeNotifier
{
  Map<String, CartItem> _items ={};

  Map<String, CartItem> get items
  {
    return {..._items};
  }

  double get totalAmount
  {
    var total= 0.0;
    _items.forEach((key, cardItem) {
      total += cardItem.price*cardItem.qty;
    });
    return total;
  }

  int get itemCount
  {
    return _items.length;
  }

  void addItem(String prodId, double price, String title)
  {
    if(_items.containsKey(prodId))
    {
      _items.update(prodId, (exCartItem)=> CartItem(
          id: exCartItem.id,
          title: exCartItem.title,
          price: exCartItem.price,
          qty: exCartItem.qty+1
      ));

    } else
    {
      _items.putIfAbsent(prodId, ()=> CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,qty: 1
      ));
    }
    notifyListeners();
  }

  void removeItem(String prodId)
  {
    _items.remove(prodId);
    notifyListeners();
  }

  void clearCart()
  {
    _items ={};
    notifyListeners();
  }

  void removeSingeItem(String productId)
  {
    if(!_items.containsKey(productId))
    {
      return;
    }

    if(_items[productId].qty>1)
    {
      _items.update(productId, (exCardItem) => CartItem(
        id: exCardItem.id,
        title: exCardItem.title,
        price: exCardItem.price,
        qty: exCardItem.qty-1,
      ));
    } else if (_items[productId].qty==1)
    {
      _items.remove(productId);
    }
    notifyListeners();
  }
}