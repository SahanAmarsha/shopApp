import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import 'product_item.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavourites;

  ProductGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final loadedProducts = showFavourites? productsData.favouriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i)=> ChangeNotifierProvider.value(
//            create: (ctx)=> loadedProducts[i],
            value: loadedProducts[i],
            child: ProductItem()
        )
    );
  }
}
