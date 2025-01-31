import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_project/model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiringDate;
  String? _userId;

  bool get isAuth {}

  String? get token {
    if (_expiringDate != null && _expiringDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=key';
    try {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _expiringDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userId = responseData['localId'];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }
    

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
<<<<<<< HEAD
}
=======

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  String get expiringDate {
    return _expiringDate;
  }
}
>>>>>>> 6ad7d135d956d2df6e37d3d6e224c23b20807bb8
