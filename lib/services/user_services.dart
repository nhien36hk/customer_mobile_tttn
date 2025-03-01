import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/user_model.dart';
import 'package:gotta_go/provider/app_infor.dart';
import 'package:provider/provider.dart';

class UserServices {
  Future<void> getInforUser(BuildContext context) async {
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth!.currentUser!.uid)
        .get();
    UserModel user = await UserModel.fromSnapshot(documentSnapshot);
    Provider.of<AppInfor>(context, listen: false).updateInforUser(user);
  }
}
