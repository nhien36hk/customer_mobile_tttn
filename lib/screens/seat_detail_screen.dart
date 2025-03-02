import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/ticket_model.dart';

class SeatDetailScreen extends StatefulWidget {
  SeatDetailScreen({super.key, required this.ticketModel});

  TicketModel ticketModel;

  @override
  State<SeatDetailScreen> createState() => _SeatDetailScreenState();
}

class _SeatDetailScreenState extends State<SeatDetailScreen> {
  int? selectedFloor = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.backgroundColor,
          title: Text(
            "Chi tiết ghế",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Colors.blue[100]!, 'Đã đặt', null),
                  const SizedBox(width: 20),
                  _buildLegendItem(Colors.white, 'Chưa đặt', null),
                  const SizedBox(width: 20),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        selectedFloor = 1;
                      }),
                      child: Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: selectedFloor == 1
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Tầng 1",
                            style: TextStyle(
                              color: selectedFloor == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        selectedFloor = 2;
                      }),
                      child: Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: selectedFloor == 2
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Tầng 2",
                            style: TextStyle(
                                color: selectedFloor == 2
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    if (selectedFloor == 1) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          String row = String.fromCharCode(65 + index ~/ 4);
                          String key = ((index % 4) + 1).toString();
                          String seat = "$row$key";
                          bool isBooked =
                              widget.ticketModel.floor1.contains(seat);
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isBooked ? Colors.blue[100] : Colors.white,
                                border: Border.all(
                                  color: isBooked
                                      ? Colors.green
                                      : Colors.green.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  seat,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isBooked
                                          ? Colors.black
                                          : Colors.grey[300]),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                    if (selectedFloor == 2) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          String row = String.fromCharCode(65 + index ~/ 4);
                          String key = ((index % 4) + 1).toString();
                          String seat = "$row$key";
                          bool isBooked =
                              widget.ticketModel.floor2.contains(seat);
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isBooked ? Colors.blue[100] : Colors.white,
                                border: Border.all(
                                  color: !isBooked
                                      ? Colors.green.shade200
                                      : Colors.green,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  seat,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isBooked
                                          ? Colors.black
                                          : Colors.grey[300]),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
