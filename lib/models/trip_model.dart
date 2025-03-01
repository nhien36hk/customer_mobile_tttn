import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  String arrivalTime;
  String busId;
  String departureTime;
  double price;
  String routeId;
  String seatLayoutId;
  String status;
  
  // Constructor yêu cầu các tham số cần thiết để khởi tạo đối tượng
  TripModel({
    required this.arrivalTime,
    required this.busId,
    required this.departureTime,
    required this.price,
    required this.routeId,
    required this.seatLayoutId,
    required this.status,
  });

  // Khởi tạo đối tượng từ DocumentSnapshot
  TripModel.fromSnapShot(DocumentSnapshot snapshot)
    : arrivalTime = snapshot['arrivalTime'],
    busId = snapshot['busId'],
    departureTime = snapshot['departureTime'],
    price = snapshot['price'],
    routeId = snapshot['routeId'],
    seatLayoutId = snapshot['seatLayoutId'],
    status = snapshot['status'];
  
}
