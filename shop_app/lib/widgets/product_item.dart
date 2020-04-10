import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../models/cart.dart';
import '../models/auth.dart';

class ProductItem extends StatelessWidget {


//  final String id;
//  final String title;
//  final String imgUrl;
//
//  ProductItem({this.id, this.title, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    final currentProduct=Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(5),

        child: GridTile(

          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: currentProduct.id);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Colors.greenAccent),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Image.network(currentProduct.imgUrl),
              ),
            ),
          ),

          footer: Container(
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: currentProduct.isFavourite? Icon(Icons.favorite):Icon(Icons.favorite_border),
                    onPressed: (){
                      currentProduct.toggleFavourite(
                          authData.token,
                          authData.userId,
                      );
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
                 Container(
                    child: Text(
                      currentProduct.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                ),
                Expanded(
                  child: IconButton
                    (icon: Icon(Icons.shopping_cart),
                    onPressed: (){
                      cart.addItem(currentProduct.id, currentProduct.price, currentProduct.title);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added Item to Cart'),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: (){
                                cart.removeSingeItem(currentProduct.id);
                              },
                            ),
                          )
                      );
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
