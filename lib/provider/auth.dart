import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_project/model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiringDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiringDate != null && _expiringDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }


  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=key';
    try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );
    final responseData = json.decode(response.body);
    print('responseData: $responseData');
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _expiringDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userId = responseData['localId'];
    } catch (error) {
      print('Authentication error: $error');
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }
    

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _expiringDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
  
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiringDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}