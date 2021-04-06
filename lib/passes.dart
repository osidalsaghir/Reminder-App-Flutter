import 'package:flutter/cupertino.dart';

class Users {
  String loginFormal = "";
  String password = "";
  Users.signup(String email, String pass, String phoneNumber) {
    loginFormal = email;
    password = pass;
    signup();
  }
  Users.signin(String phoneNumber, String pass) {
    loginFormal = phoneNumber;
    password = pass;
  }

  dynamic _login() {}

  bool signup() {
    return true;
  }
}
