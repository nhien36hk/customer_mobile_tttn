import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/pickup_location_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  SeatSelectionScreen({super.key, required this.schedule});

  final ScheduleModel schedule;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int selectedFloor = 1;
  Set<String> selectedSeats1 = {};
  Set<String> selectedSeats2 = {};
  int? defaultPriceFloor1;
  int? defaultPriceFloor2;

  Map<String, dynamic> floor1 = {};
  Map<String, dynamic> floor2 = {};
  late Future<void> _seatLayoutFuture;

  Future<void> getSeatLayout() async {
    DocumentSnapshot seatLayoutDoc = await firebaseFirestore
        .collection("seatLayouts")
        .doc(widget.schedule.seatLayoutId)
        .get();

    Map<String, dynamic> seatLayoutMap =
        seatLayoutDoc.data() as Map<String, dynamic>;
    setState(() {
      defaultPriceFloor1 = seatLayoutMap['defaultPriceFloor1'];
      defaultPriceFloor2 = seatLayoutMap['defaultPriceFloor1'];
      floor1 = seatLayoutMap['floor1'];
      floor2 = seatLayoutMap['floor2'];
    });
  }

  @override
  void initState() {
    super.initState();
    _seatLayoutFuture = getSeatLayout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          'Chọn ghế',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: _seatLayoutFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã có lỗi xảy ra: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _seatLayoutFuture = getSeatLayout();
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressIcon(Icons.directions_bus, true),
                      _buildProgressLine(true),
                      _buildProgressIcon(Icons.swap_horiz, true),
                      _buildProgressLine(false),
                      _buildProgressIcon(Icons.person_outline, false),
                      _buildProgressLine(false),
                      _buildProgressIcon(Icons.payment, false),
                    ],
                  ),
                ),
              ),

              // Seat Legend
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildLegendItem(
                          Colors.grey[300]!, 'Đã bán', Icons.clear),
                      const SizedBox(width: 20),
                      _buildLegendItem(Colors.blue[100]!, 'Đang chọn', null),
                      const SizedBox(width: 20),
                      _buildLegendItem(Colors.white, 'Chưa đặt', null),
                      const SizedBox(width: 20),
                      _buildLegendItem(Colors.green[100]!, 'Phòng đôi', null,
                          'Phòng Đôi nằm 2 khách\ndưới 140kg (750.000 đ)'),
                    ],
                  ),
                ),
              ),

              // Floor Selection
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedFloor = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedFloor == 1
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Tầng 1',
                              style: TextStyle(
                                color: selectedFloor == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedFloor = 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedFloor == 2
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Tầng 2',
                              style: TextStyle(
                                color: selectedFloor == 2
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Seat Grid
              Expanded(
                child: Column(
                  children: [
                    // Tầng 1
                    if (selectedFloor == 1) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          String row = String.fromCharCode(65 + index ~/ 4);
                          String Key = (index % 4 + 1).toString();
                          String seatKey = '$row$Key';
                          bool isSelected = selectedSeats1.contains(seatKey);
                          bool isExist = floor1[seatKey] != null;
                          bool isBooked =
                              isExist && floor1[seatKey]['isBooked'] ?? false;

                          return GestureDetector(
                            onTap: isBooked
                                ? null
                                : () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSeats1.remove(seatKey);
                                      } else {
                                        if (selectedSeats1.length < 12) {
                                          selectedSeats1.add(seatKey);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Đã chọn ghế $seatKey'),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Bạn chỉ có thể chọn tối đa 12 ghế'),
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !isExist
                                    ? Colors.transparent
                                    : isBooked
                                        ? Colors.grey[300]
                                        : isSelected
                                            ? Colors.blue[100]
                                            : Colors.white,
                                border: Border.all(
                                  color: !isExist
                                      ? Colors.transparent
                                      : Colors.green,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: isBooked
                                    ? const Icon(Icons.clear,
                                        color: Colors.grey)
                                    : Text(
                                        !isExist ? "" : seatKey,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    // Tầng 2
                    if (selectedFloor == 2) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          String row = String.fromCharCode(65 + index ~/ 4);
                          String Key = (index % 4 + 1).toString();
                          String seatKey = '$row$Key';
                          bool isSelected = selectedSeats2.contains(seatKey);
                          bool isExist = floor2[seatKey] != null;
                          bool isBooked =
                              isExist && floor2[seatKey]['isBooked'] ?? false;

                          return GestureDetector(
                            onTap: isBooked
                                ? null
                                : () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSeats2.remove(seatKey);
                                      } else {
                                        if (selectedSeats2.length < 12) {
                                          selectedSeats2.add(seatKey);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Đã chọn ghế $seatKey'),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Bạn chỉ có thể chọn tối đa 12 ghế'),
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isBooked
                                    ? Colors.grey[300]
                                    : isSelected
                                        ? Colors.blue[100]
                                        : Colors.white,
                                border: Border.all(
                                  color: !isExist ? Colors.transparent : Colors.green,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: isBooked
                                    ? const Icon(Icons.clear,
                                        color: Colors.grey)
                                    : Text(
                                        !isExist ? "" : seatKey,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: selectedSeats1.isNotEmpty ||
                          selectedSeats2.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickupLocationScreen(
                                tripModel: widget.schedule,
                                seatBookingModel: SeatBookingModel(
                                    selectSeatFloor1: selectedSeats1,
                                    selectSeatFloor2: selectedSeats2,
                                    defaultPriceFloor1: defaultPriceFloor1!,
                                    defaultPriceFloor2: defaultPriceFloor2!),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        selectedSeats1.isNotEmpty || selectedSeats2.isNotEmpty
                            ? 'Tiếp tục (${selectedSeats1.length + selectedSeats2.length} ghế)'
                            : 'Vui lòng chọn ghế',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isActive ? Constants.backgroundColor : Colors.grey,
          shape: BoxShape.circle),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? Constants.backgroundColor : Colors.grey,
    );
  }

  Widget _buildLegendItem(Color color, String text, IconData? icon,
      [String? tooltip]) {
    return Tooltip(
      message: "Đây là tooltip",
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child:
                icon != null ? Icon(icon, size: 16, color: Colors.grey) : null,
          ),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
