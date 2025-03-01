import 'package:cloud_firestore/cloud_firestore.dart';

class SeatLayoutModel {
  List<Map<String, dynamic>> floor1;
  List<Map<String, dynamic>> floor2;
  SeatLayoutModel({
    required this.floor1,
    required this.floor2,
  });

  SeatLayoutModel.fromSnapshot(DocumentSnapshot snapshot) 
    : floor1 = snapshot['floor1'],
      floor2 = snapshot['floor2'];
}
