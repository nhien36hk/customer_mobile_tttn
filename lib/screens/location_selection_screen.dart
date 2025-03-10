import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:http/http.dart' as http;

class LocationSelectionScreen extends StatefulWidget {
  LocationSelectionScreen({super.key, required this.isForm});

  bool isForm;

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  int _selectedTab = 0;
  List<String> provinces = [];
  bool isLoading = true;
  List<String> predictProvices = [];
  Future<void> getProvince() async {
    try {
      final result = await http
          .get(Uri.parse("https://provinces.open-api.vn/api/?depth=2"));
      if (result.statusCode == 200) {
        // Decode response body với UTF-8
        String decodedBody = utf8.decode(result.bodyBytes);
        List<dynamic> data = jsonDecode(decodedBody);

        setState(() {
          provinces =
              data.map((province) => province['name'].toString()).toList();

          print("Tỉnh $provinces");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Lỗi gửi http tìm tỉnh $e");
    }
  }

  searchProvince(String value) {
    setState(() {
      predictProvices = provinces
          .where((provice) => provice.toLowerCase().contains(value.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvince();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          'Chọn nơi bạn muốn đi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
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
              onChanged: (value) {
                searchProvince(value);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTab('Tỉnh thành', 0),
                const SizedBox(width: 20),
                _buildTab('Quận huyện', 1),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : predictProvices.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: predictProvices.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(predictProvices[index]),
                            onTap: () {
                              Navigator.pop(context, predictProvices[index]);
                            },
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: provinces.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(provinces[index]),
                            onTap: () {
                              Navigator.pop(context, provinces[index]);
                            },
                          );
                        },
                      ),
                    )
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    isSelected ? Constants.backgroundColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Constants.backgroundColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
