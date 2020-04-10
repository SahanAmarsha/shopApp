import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/order_button.dart';
import '../widgets/cart_item.dart';
import '../models/orders.dart';
import '../models/cart.dart' show Cart;

class CartScreen extends StatelessWidget {

  static const routeName ='/cart';



  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: (
          Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total', style: TextStyle(
                        fontSize: 20,
                      ),),
                      Spacer(),
                      Chip(
                        label: Text( '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryTextTheme.title.color,
                          ),),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 10,),
                      OrderButton(context, cart),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      prodId: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      price: cart.items.values.toList()[i].price,
                      qty: cart.items.values.toList()[i].qty
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
