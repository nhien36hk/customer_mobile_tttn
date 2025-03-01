import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String phone;
  String? date;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      this.date});

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        email = snapshot['email'],
        phone = snapshot['phone'],
        date = (snapshot.data() as Map<String, dynamic>).containsKey("date")
            ? snapshot.get("date")
            : null;
}
