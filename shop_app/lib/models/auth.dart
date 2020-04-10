import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/htttp_exception.dart';

class Auth with ChangeNotifier
{
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth
  {
    return (token!=null);
  }

  String get userId
  {
    return _userId;
  }
  String get token
  {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token!=null)
    {
      return _token;
    } else
    {
      return null;
    }
  }


  //SignUp Method
  Future<void> signUp(String email, String password) async
  {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBFTWD--fv0gPBbab-IVGBXOsAO3_OMVFI';
    try
    {
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      })
      );

      final responseData = json.decode(response.body);
      if(responseData['error'] !=  null)
      {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error)
    {
      throw error;
    }

  }


  //LogIn Method
  Future<void> logIn(String email, String password) async
  {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBFTWD--fv0gPBbab-IVGBXOsAO3_OMVFI';
    try{

      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      })
      );

      final responseData = json.decode(response.body);
      if(responseData['error']!=null)
      {
        print(responseData['error'].toString());
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error)
    {
      print(error);
      throw error;
    }


  }

  Future<bool> tryAutoLogin() async
  {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('userData'))
    {
      final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
      final expDate = DateTime.parse(extractedUserData['expiryDate']);

      if(expDate.isBefore(DateTime.now()))
        {
          return false;
        }
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expDate;
      notifyListeners();
      autoLogOut();
      return true;

    } else
    {
      return false;
    }
  }

  Future<void>  logOut() async
  {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null)
    {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogOut()
  {
    if(_authTimer != null)
    {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
        Duration(seconds: timeToExpiry),
        logOut
    );
  }
}