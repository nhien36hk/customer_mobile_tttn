import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  String arrivalTime;
  String busId;
  String departureTime;
  int price;
  String routeId;
  String seatLayoutId;
  int? emptySeats;
  String nameCar;
  String startLocation;
  String endLocation;

  ScheduleModel({
    required this.arrivalTime,
    required this.busId,
    required this.departureTime,
    required this.price,
    required this.routeId,
    required this.seatLayoutId,
    required this.nameCar,
    required this.startLocation,
    required this.endLocation,
    this.emptySeats,
  });

  ScheduleModel.fromSnapshot(DocumentSnapshot snapshot, int emptySeats,
      String nameCar, String startLocation, String endLocation)
      : arrivalTime = snapshot['arrivalTime'],
        busId = snapshot['busId'],
        departureTime = snapshot['departureTime'],
        price = snapshot['price'],
        routeId = snapshot['routeId'],
        seatLayoutId = snapshot['seatLayoutId'],
        startLocation = startLocation,
        endLocation = endLocation,
        emptySeats = emptySeats,
        nameCar = nameCar;
}
