import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/htttp_exception.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier
{
  //var _showFavouritesOnly =false;

  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this._items, this.userId);

  List<Product> _items =
  [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      desc: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imgUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      desc: 'A nice pair of trousers.',
//      price: 59.99,
//      imgUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      desc: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imgUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      desc: 'Prepare any meal you want.',
//      price: 49.99,
//      imgUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  List<Product> get items
  {

    return[..._items];


  }

  List<Product> get favouriteItems
  {
    return _items.where((prodItem) => prodItem.isFavourite==true).toList();
  }

//  void showFavouritesOnly()
//  {
//    _showFavouritesOnly=true;
//    notifyListeners();
//  }
//
//  void showAll()
//  {
//    _showFavouritesOnly=false;
//    notifyListeners();
//  }
  //-----------fetching the products------------
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async
  {
    final filterString = filterByUser?  'orderBy="creatorId"&equalTo="$userId"' : '';
    try{
      var url = 'https://flutter-project1-c23eb.firebaseio.com/products.json?auth=$authToken&$filterString';
      final response =  await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(extractedData == null)
        {
          return;
        }

      url = 'https://flutter-project1-c23eb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);


      extractedData.forEach((prodId, prodData){
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          desc: prodData['description'],
          price: prodData['price'],
          isFavourite: favouriteData==null? false : favouriteData[prodId]?? false ,
          imgUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch(error)
    {
      print(error);
      throw(error);
    }

  }


  //-----------adding a new product-------------
  Future<void> addProduct (Product product) async
  {
    //_items.add(value);
    final url = 'https://flutter-project1-c23eb.firebaseio.com/products.json?auth=$authToken';
    try{
      final response = await http.post(url, body: json.encode({
        'title' : product.title,
        'description' : product.desc,
        'imageUrl' : product.imgUrl,
        'price' : product.price,
        'creatorId' : userId,
      }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          desc: product.desc,
          price: product.price,
          imgUrl: product.imgUrl,
      );
      _items.add(newProduct);
      notifyListeners();

    }  catch (error)
    {
      print (error);
      throw (error);
    }




  }

  Product findById(String id)
  {
    return _items.firstWhere((prod) => prod.id== id);
  }

  Future<void> updateProduct(String id, Product newProduct) async
  {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0)
    {
      final url = 'https://flutter-project1-c23eb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url, body: json.encode({
        'title' : newProduct.title,
        'description' : newProduct.desc,
        'imageUrl' : newProduct.imgUrl,
        'price' : newProduct.price,
      })
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
    {
      print('...');
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async
  {
    final url = 'https://flutter-project1-c23eb.firebaseio.com/products/$id.json?auth=$authToken';
    final exProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exProduct = _items[exProductIndex];
    _items.removeAt(exProductIndex);
    notifyListeners();
    final response = await http.delete(url);
        if(response.statusCode >= 400)
      {
        _items.insert(exProductIndex, exProduct);
        notifyListeners();
        throw HttpException('Could not delete Product');
      }
      exProduct = null;

//    _items.removeWhere((prod) => prod.id == id);

  }
}