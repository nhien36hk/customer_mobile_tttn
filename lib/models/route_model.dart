import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gotta_go/constants/global.dart';

class RouteModel {
  String fromLocation;
  String toLocation;
  String distance;
  int totalTime;
  String price;

  Future<int> calculateTotalTime(String routeId) async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection("schedules")
        .where("routeId", isEqualTo: routeId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      DateTime departureTime = doc['departureTime'];
      DateTime arrivalTime = doc['arrivalTime'];
      return arrivalTime.difference(departureTime).inHours;
    }
    return 0; // Trả về 0 nếu không tìm thấy lịch trình
  }

  RouteModel.fromSnapshot(DocumentSnapshot snapshot)
      : fromLocation = snapshot['from'],
        toLocation = snapshot['to'],
        distance = snapshot['distance'],
        price = snapshot['price'],
        totalTime = 0 {
    calculateTotalTime(snapshot.id).then((value) => totalTime = value);
  }
}
