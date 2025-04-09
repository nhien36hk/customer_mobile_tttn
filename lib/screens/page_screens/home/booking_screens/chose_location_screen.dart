import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/page_screens/home/booking_screens/booking_information.dart';
import 'package:gotta_go/widgets/warning_widget.dart';

class ChoseLocationScreen extends StatefulWidget {
  ChoseLocationScreen(
      {super.key, required this.tripModel, required this.seatBookingModel});

  ScheduleModel tripModel;
  SeatBookingModel seatBookingModel;

  @override
  State<ChoseLocationScreen> createState() => _ChoseLocationScreenState();
}

class _ChoseLocationScreenState extends State<ChoseLocationScreen> {
  String? startLocation;
  String? endLocation;
  int? selectedIndex = 1;
  String? from;
  String? to;

  void startAndEndPoint() async {
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection("routes")
        .doc(widget.tripModel.routeId)
        .get();
    setState(() {
      startLocation = documentSnapshot['startPoint'];
      endLocation = documentSnapshot['endPoint'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startAndEndPoint();
  }

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
                GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = 1;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: selectedIndex == 1
                          ? Colors.blue[50]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedIndex != 2 ? 'Điểm đón' : from.toString(),
                          style: TextStyle(
                            color:
                                selectedIndex == 1 ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = 2;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: selectedIndex == 2
                          ? Colors.blue[50]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          to == null ? 'Điểm trả' : to.toString(),
                          style: TextStyle(
                            color:
                                selectedIndex == 2 ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
          selectedIndex == 1
              ? Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            from = startLocation;
                            selectedIndex = 2;
                          });
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                          title: Text(
                            startLocation.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('01 Đường Tô Hiến Thành'),
                          trailing: Text(
                            '13:30',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {
                          setState(() {
                            to = endLocation;
                          })
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                          title: Text(
                            endLocation.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('19 Nguyễn Gia Trí'),
                          trailing: Text(
                            '13:30',
                            style: TextStyle(color: Colors.grey),
                          ),
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
                  (from == null && to == null)
                      ? showDialog(
                          context: context,
                          builder: (context) => WarningWidget(
                              colorInfor: Colors.red,
                              textWarning:
                                  "Vui lòng chọn điểm đón và điểm trả!"),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingInformation(
                              trip: widget.tripModel,
                              seatBookingModel: widget.seatBookingModel,
                            ),
                          ),
                        );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (from != null && to != null)
                      ? Constants.backgroundColor
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Tiếp tục',
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
