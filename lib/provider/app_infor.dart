import 'package:flutter/material.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/user_model.dart';

class AppInfor with ChangeNotifier {
  UserModel? userInfor;
  void updateInforUser(UserModel user) {
    userInfor = user;
    notifyListeners();
  }
}
