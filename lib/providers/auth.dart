import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthMode { login, signup }
enum UserType { students, instructors }

extension on UserType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class Auth with ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  FirebaseUser _user;

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  AuthMode _authMode = AuthMode.login;
  UserType _userType = UserType.students;
  bool _isLogin = true;
  bool _isLoading = false;

  AuthMode get authMode {
    return this._authMode;
  }

  set authMode(AuthMode authMode) {
    this._authMode = authMode;
    this._isLogin = _authMode == AuthMode.login ? true : false;
    notifyListeners();
  }

  UserType get userType {
    return this._userType;
  }

  set userType(UserType userType) {
    this._userType = userType;
    notifyListeners();
  }

  set userTypeFromString(String userType) {
    this._userType =
        userType == 'students' ? UserType.students : UserType.instructors;
    notifyListeners();
  }

  String _userTypeCollection() {
    return this._userType == UserType.students ? "students" : "instructors";
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

  Future<void> _authenticate(String email, String password, String operation,
      String fullName, String collegeId) async {
    //  Sign up
    if (operation == "signup") {
      _user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      //  Set user's type in firestore -> Collection('users')
      _firestore.collection(_userTypeCollection()).document(userId).setData({
        'fullName': fullName,
        'email': email,
        if (userType == UserType.students) 'collegeId': collegeId
      });
    }
    //  Sign in
    else {
      _user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    }

    //  Extract user's Token
    IdTokenResult idTokenResult = (await _user.getIdToken());
    _token = idTokenResult.token;
    _userId = _user.uid;
    _expiryDate = idTokenResult.expirationTime;
    _autoLogout();

    //  Fetch user's type from firestore
    _firestore
        .collection('users')
        .document(userId)
        .setData({'userType': userType.toShortString()});

    userTypeFromString =
        (await _firestore.collection('users').document(userId).get())
            .data['userType'];

    //  Save user's session in sharedpreferences == local storage
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'userType': userType.toShortString(),
      },
    );
    prefs.setString('userData', userData);
  }

  Future<void> signup(
      String email, String password, String fullName, String collegeId) async {
    return _authenticate(email, password, 'signup', fullName, collegeId);
  }

  Future<void> login(
      String email, String password, String fullName, String collegeId) async {
    return _authenticate(email, password, 'signin', fullName, collegeId);
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
