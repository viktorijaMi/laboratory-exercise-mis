import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserNotifier extends ChangeNotifier {
  User? user;

  UserNotifier({this.user});

  UserNotifier get state => this;

  void setUser(User? user) {
    this.user = user;
    notifyListeners();
  }
}