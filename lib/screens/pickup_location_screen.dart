import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/trip_detail_screen.dart';

class PickupLocationScreen extends StatelessWidget {
  PickupLocationScreen({super.key, required this.tripModel, required this.seatBookingModel});

  ScheduleModel tripModel;
  SeatBookingModel seatBookingModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          'Chọn điểm đón & trả a',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Điểm đón a',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Điểm trả',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm Tỉnh / Thành, Quận / Huyện',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Bến xe liên tỉnh Đà Lạt',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('01 Đường Tô Hiến Thành'),
                  trailing: Text(
                    '13:30',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailScreen(trip: tripModel, seatBookingModel: seatBookingModel,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Tiếp tục a' ,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
