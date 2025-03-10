import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  String arrivalTime;
  String busId;
  String departureTime;
  String price;
  String routeId;
  String seatLayoutId;
  int? emptySeats;
  String nameCar;
  String startLocation;
  String endLocation;
  String scheduleId;

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
    required this.scheduleId,
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
        scheduleId = snapshot.id,
        nameCar = nameCar;
}
