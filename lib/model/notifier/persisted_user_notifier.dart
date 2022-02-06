import 'package:flutter/widgets.dart';
import 'package:lab3_mis/model/user.dart';

class PersistedUserNotifier extends ChangeNotifier {
  PersistedUser? user;

  PersistedUserNotifier({this.user});

  PersistedUserNotifier get state => this;

  void setUser(PersistedUser? user) {
    this.user = user;
    notifyListeners();
  }
}