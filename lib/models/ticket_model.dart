import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  String arrivalTime;
  Timestamp bookingTime;
  String busId;
  String customerId;
  String departureTime;
  String from;
  int price;
  String routeId;
  String scheduleId;
  String seatLayoutId;
  List<String> floor1;
  List<String> floor2;
  String status;
  String to;

  TicketModel({
    required this.arrivalTime,
    required this.bookingTime,
    required this.busId,
    required this.customerId,
    required this.departureTime,
    required this.floor1,
    required this.floor2,
    required this.from,
    required this.price,
    required this.routeId,
    required this.scheduleId,
    required this.seatLayoutId,
    required this.status,
    required this.to,
  });

  TicketModel.fromSnapshot(DocumentSnapshot snapshot)
      : arrivalTime = snapshot['arrivalTime'],
        bookingTime = snapshot['bookingTime'],
        busId = snapshot['busId'],
        customerId = snapshot['customerId'],
        departureTime = snapshot['departureTime'],
        floor1 =
            List<String>.from(snapshot['seatNumber']['floor1'].cast<String>()),
        floor2 =
            List<String>.from(snapshot['seatNumber']['floor2'].cast<String>()),
        from = snapshot['from'],
        price = snapshot['price'],
        routeId = snapshot['routeId'],
        scheduleId = snapshot['scheduleId'],
        seatLayoutId = snapshot['seatLayoutId'],
        status = snapshot['status'],
        to = snapshot['to'];
}
