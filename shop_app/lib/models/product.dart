import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier
{
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imgUrl;
  bool isFavourite;

  Product({@required this.id, @required this.title,@required  this.desc,@required  this.price,@required  this.imgUrl, this.isFavourite=false});

  Future<void> toggleFavourite(String token, String userId) async
  {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://flutter-project1-c23eb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try{
     final response =  await http.put(url, body: json.encode(
        isFavourite,
     )
      );
     if(response.statusCode >= 400)
       {
         isFavourite = oldStatus;
         notifyListeners();

       }
      notifyListeners();
    } catch(error)
    {
      isFavourite = oldStatus;
      notifyListeners();

    }

  }
}