import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class AuthController extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      _user = User(email, password);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    // Here you would add your authentication logic, for example, a call to your API
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    _user = User(email, password);
    notifyListeners();

    // Print email and password to console after saving them
    print('Email: $email');
    print('Password: $password');
  }

  Future<void> signup(String name, String email, String password) async {
    // Here you would add your sign-up logic, for example, a call to your API
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    _user = User(email, password);
    notifyListeners();

    // Print email and password to console after saving them
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');

    _user = null;
    notifyListeners();
  }
}
