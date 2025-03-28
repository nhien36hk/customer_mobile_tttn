import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/screens/date_selection_screen.dart';
import 'package:gotta_go/screens/search_location_screen.dart';
import 'package:gotta_go/screens/search_trip_screen.dart';
import 'package:gotta_go/services/bus_services.dart';
import 'package:gotta_go/services/popular_routes_service.dart';
import 'package:gotta_go/services/user_services.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:gotta_go/widgets/warning_widget.dart';
import 'package:gotta_go/widgets/search_history_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fromLocation;
  String? toLocation;
  DateTime? selectedDate;
  bool isLoading = true;
  List<Map<String, dynamic>> _popularRoutes = [];

  void _selectFromLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchLocationScreen(
          isForm: true,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        fromLocation = result;
      });
    }
  }

  void _selectToLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchLocationScreen(
                isForm: false,
              )),
    );
    if (result != null) {
      setState(() {
        toLocation = result;
      });
    }
  }

  void _selectDate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DateSelectionScreen(
                isHome: true,
              )),
    );
    if (result != null) {
      setState(() {
        print("Ngay ne" + result.toString());
        selectedDate = result;
      });
    }
  }

  void _onHistorySelected(String fromLoc, String toLoc, DateTime date) {
    setState(() {
      fromLocation = fromLoc;
      toLocation = toLoc;
      selectedDate = date;
    });

    // Hiển thị loading và thực hiện tìm kiếm
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoadingWidget());

    BusServices.searchTrips(fromLocation!, toLocation!, selectedDate!, context);
  }

  @override
  void initState() {
    super.initState();
    UserServices().getInforUser(context);
    _loadPopularRoutes();
  }

  Future<void> _loadPopularRoutes() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final routes = await PopularRoutesService.getPopularRoutes();
      if (mounted) {
        setState(() {
          _popularRoutes = routes;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Lỗi khi tải lộ trình phổ biến: $e");
      Fluttertoast.showToast(
          msg: "Không thể tải lộ trình phổ biến", backgroundColor: Colors.red);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background header
          Container(
            width: double.infinity,
            height: 200, // Chiều cao cố định cho header
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào Đình Trung',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Chúc bạn sáng chủ nhật vui vẻ',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search container
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search box
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10), // Thêm margin top
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Constants.backgroundColor,
                                          size: 19,
                                        ),
                                        Container(
                                          height: 45,
                                          width: 1,
                                          color: Constants.backgroundColor,
                                        ),
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Constants.backgroundColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: _selectFromLocation,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nơi đi",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: TextField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: fromLocation ??
                                                          'Nơi đi',
                                                      hintStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            fromLocation != null
                                                                ? Colors.black
                                                                : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                              thickness: 1,
                                              color: Colors.grey[300]),
                                          GestureDetector(
                                            onTap: _selectToLocation,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nơi đến",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: TextField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: toLocation ??
                                                          'Nơi đến',
                                                      hintStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color:
                                                            toLocation != null
                                                                ? Colors.black
                                                                : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.swap_vert,
                                        size: 30,
                                        color: Constants.backgroundColor,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: _selectDate,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          "Ngày khởi hành  ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Constants.backgroundColor,
                                              size: 30,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              selectedDate != null
                                                  ? 'Ngày ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                                  : 'Chọn ngày',
                                              style: TextStyle(
                                                color: selectedDate != null
                                                    ? Colors.black
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (fromLocation != null &&
                                    toLocation != null &&
                                    selectedDate != null) {
                                  // Hiển thị loading
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => LoadingWidget());

                                  BusServices.searchTrips(fromLocation!,
                                      toLocation!, selectedDate!, context);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => WarningWidget(
                                      textWarning:
                                          "Vui lòng chọn đầy đủ thông tin",
                                      colorInfor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.backgroundColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: const Text(
                                'Tìm chuyến đi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Lịch sử tìm kiếm
                          if (firebaseAuth.currentUser != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: SearchHistoryWidget(
                                onHistorySelected: _onHistorySelected,
                              ),
                            ),

                          const SizedBox(height: 30),

                          // Lộ trình phổ biến
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Lộ trình phổ biến',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _popularRoutes.length,
                                  itemBuilder: (context, index) {
                                    final route = _popularRoutes[index];
                                    return GestureDetector(
                                      onTap: () {
                                        PopularRoutesService
                                            .navigateToSearchTrip(
                                                context, route);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            size: 12,
                                                            color: Constants
                                                                .buttonColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          SizedBox(
                                                            width: 150,
                                                            child: Text(
                                                              route['from'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 5),
                                                        width: 1,
                                                        height: 20,
                                                        color: Constants
                                                            .buttonColor,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on,
                                                            size: 12,
                                                            color: Constants
                                                                .buttonColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            route['to'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    height: 120,
                                                    width: 150,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.asset(
                                                        route['image'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: double.infinity,
                                                child: DefaultTextStyle(
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 11,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.route,
                                                              size: 14,
                                                              color: Colors
                                                                  .grey[600]),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            route['distance'],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                              Icons.access_time,
                                                              size: 14,
                                                              color: Colors
                                                                  .grey[600]),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            route['duration'],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .attach_money,
                                                              size: 14,
                                                              color: Colors
                                                                  .grey[600]),
                                                          Text(
                                                            route['price'],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(
                              height: 100), // Space for bottom navigation
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
