import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String prodId;
  final String title;
  final double price;
  final int qty;

  CartItem({this.id, this.prodId, this.title, this.price, this.qty});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart'),
            actions: <Widget>[
              OutlineButton(
                child: Text('No'),
                color: Color.fromRGBO(248, 249, 250, 1),
                onPressed: ()
                {
                  Navigator.of(ctx).pop(false);
                },
                textColor: Theme.of(context).primaryColor,
                shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
              OutlineButton(
                child: Text('Yes'),
                color: Color.fromRGBO(248, 249, 250, 1),
                onPressed: ()
                {
                  Navigator.of(ctx).pop(true);
                },
                textColor: Theme.of(context).primaryColor,
                shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ],
          )
        );
      },
      onDismissed: (direction)
      {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(

              child: Padding(
                padding: EdgeInsets.all(4),
                child: FittedBox(
                    child: Text('\$${price}')
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price*qty}'),
            trailing: Text('$qty x'),
          ),
        ),
      ),
    );
  }
}
