import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/screens/location_selection_screen.dart';
import 'package:gotta_go/screens/date_selection_screen.dart';
import 'package:gotta_go/screens/trip_list_screen.dart';
import 'package:gotta_go/services/bus_services.dart';
import 'package:gotta_go/services/user_services.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
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

  void _selectFromLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
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
          builder: (context) => LocationSelectionScreen(
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
      MaterialPageRoute(builder: (context) => const DateSelectionScreen()),
    );
    if (result != null) {
      setState(() {
        print("Ngay ne" + result.toString());
        selectedDate = result;
      });
    }
  }

  // Thêm dữ liệu giả cho lộ trình phổ biến
  final List<Map<String, dynamic>> _popularRoutes = const [
    {
      'from': 'Đà Lạt',
      'to': 'TP Hồ Chí Minh',
      'distance': '310 km',
      'duration': '~6 giờ',
      'price': '150.000đ',
      'image': 'images/dalat.jpg',
    },
    {
      'from': 'Đà Lạt',
      'to': 'Đồng Nai',
      'distance': '217 km',
      'duration': '~5 giờ',
      'price': '130.000đ',
      'image': 'images/dalat.jpg',
    },
    {
      'from': 'Đà Lạt',
      'to': 'Hà Tiên',
      'distance': '614 km',
      'duration': '~12 giờ',
      'price': '250.000đ',
      'image': 'images/dalat.jpg',
    },
    {
      'from': 'Đồng Nai',
      'to': 'Hà Tiên',
      'distance': '450 km',
      'duration': '~9 giờ',
      'price': '200.000đ',
      'image': 'images/dalat.jpg',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserServices().getInforUser(context);
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Vui lòng chọn đầy đủ thông tin'),
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
                          // Recent searches section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tìm kiếm gần đây',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Xóa tất cả',
                                      style: TextStyle(
                                        color: Constants.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 15),
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.circle_outlined,
                                              color: Constants.backgroundColor,
                                              size: 19,
                                            ),
                                            Container(
                                              height: 10,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hồ Chí Minh',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              'Lâm Đồng',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Thứ ba, 21/01/2024',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            border: Border.all(
                                              color: Constants.backgroundColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Constants.backgroundColor,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // News section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Lộ trình phổ biến',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                        color: Constants.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _popularRoutes.length,
                                itemBuilder: (context, index) {
                                  final route = _popularRoutes[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 15),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.circle_outlined,
                                                        size: 12,
                                                        color: Constants
                                                            .buttonColor,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        route['from'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    width: 1,
                                                    height: 20,
                                                    color:
                                                        Constants.buttonColor,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_on,
                                                        size: 12,
                                                        color: Constants
                                                            .buttonColor,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        route['to'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      BorderRadius.circular(15),
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
                                                          color:
                                                              Colors.grey[600]),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        route['distance'],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.access_time,
                                                          size: 14,
                                                          color:
                                                              Colors.grey[600]),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        route['duration'],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.attach_money,
                                                          size: 14,
                                                          color:
                                                              Colors.grey[600]),
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
                                  );
                                },
                              ),
                              const SizedBox(
                                  height: 100), // Space for bottom navigation
                            ],
                          ),
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
