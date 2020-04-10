import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'edit_products_screen.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';


class UserProductsScreen extends StatelessWidget {

  static const routeName='/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {

    //setting up a listener to ProductsProvider(for our products)
    //final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()
            {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot)=>snapShot.connectionState == ConnectionState.waiting?
          Center(
            child: CircularProgressIndicator(),
          ) :
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductProvider>(
            builder: (ctx, productsData, _) =>Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, i) => Column(
                    children: <Widget>[
                      UserProductItem(productsData.items[i].id, productsData.items[i].title,productsData.items[i].imgUrl),
                      Divider()
                    ],
                  )
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
