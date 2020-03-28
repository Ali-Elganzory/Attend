import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

enum AuthMode { login, signup }

class Auth with ChangeNotifier {
  AuthMode _authMode = AuthMode.login;
  bool _isLogin = true;
  bool _isLoading = false;

  set authMode(AuthMode authMode) {
    this._authMode = authMode;
    this._isLogin = _authMode == AuthMode.login ? true : false;
    notifyListeners();
  }

  AuthMode get authMode {
    return this._authMode;
  }

  bool get isLogin {
    return this._isLogin;
  }

  set isLoading(bool isLoading) {
    this._isLoading = isLoading;
    notifyListeners();
  }

  bool get isLoading {
    return this._isLoading;
  }

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String fullName, String urlSegment) async {
    String url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyB7yt-GQMFt4oEVzLYSZpdpcaH7VPyqfgU';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      notifyListeners();

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();

      if (urlSegment == 'signupNewUser') {
        url =
            'https://firestore.googleapis.com/v1/projects/attend-1a9b5/databases/(default)/documents/students/$userId';

        response = await http.patch(url,
            headers: {"Authorization": 'Bearer $token'},
            body: json.encode({
              "fields": {
                'fullName': {'stringValue': fullName},
                'email': {'stringValue': email},
                'phone': {'nullValue': null},
                'address': {'nullValue': null}
              }
            }));
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password, String fullName) async {
    try {
      return _authenticate(email, password, fullName, 'signupNewUser');
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password, String fullName) async {
    try {
      return _authenticate(email, password, fullName, 'verifyPassword');
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
