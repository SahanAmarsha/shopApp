import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import 'cart_screen.dart';

enum FilterOptions
{
  Favourites,
  All
}

class ProductsOverviewScreen extends StatefulWidget {




  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<ProductProvider>(context).fetchAndSetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit)
      {
        setState(() {
          _isLoading = true;
        });

        Provider.of<ProductProvider>(context).fetchAndSetProducts().then((_)
        {
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
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions  selectedValue) {
              setState(() {
                if(selectedValue == FilterOptions.Favourites)
                {
                  _showOnlyFavourites=true;
                } else
                {
                  _showOnlyFavourites=false;
                }
              });

            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_)=>[
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch)=> Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: ()
              {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: _isLoading?
          Center(
           child: CircularProgressIndicator(),
          )
          :ProductGrid(_showOnlyFavourites),
      drawer: AppDrawer(),
    );
  }
}

