import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orders.dart';
import '../models/cart.dart';

class OrderButton extends StatefulWidget {

  final Cart cart;
  final BuildContext context;

  OrderButton(this.context, this.cart);

  Future<void> _saveOrder(BuildContext context, Cart cart, ) async
  {
    try{
      await Provider.of<Orders>(context, listen: false).addOrder(
          cart.items.values.toList(),
          cart.totalAmount
      );

      cart.clearCart();
    } catch(error)
    {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Ordering Failed!', textAlign: TextAlign.center,),
          )
      );
    }

  }


  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: _isLoading? CircularProgressIndicator() : Text('ORDER NOW'),
      color: Color.fromRGBO(248, 249, 250, 1),
      onPressed: ()
      {
        if(widget.cart.totalAmount<=0 || _isLoading)
        {

          return null;
        } else
        {
          setState(() {
            _isLoading = true;
          });
          widget._saveOrder(context, widget.cart);
          setState(() {
            _isLoading = false;
          });
        }

      },
      textColor: Theme.of(context).primaryColor,
      shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );
  }
}
