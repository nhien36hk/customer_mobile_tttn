import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';

class LocationSelectionScreen extends StatefulWidget {
  LocationSelectionScreen({super.key, required this.isForm});

  bool isForm;

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  int _selectedTab = 0;
  List<String> _startProvinces = [];
  List<String> _endProvinces = [];

  Future<void> getProvince() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection("routes").get();
    setState(() {
      _startProvinces = querySnapshot.docs.map((doc) {
        return doc['startPoint'].toString();
      }).toList();

      _endProvinces = querySnapshot.docs.map((doc) {
        return doc['endPoint'].toString();
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late();
  }

  void late() async {
    await getProvince();
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.isForm ? _startProvinces.length : _endProvinces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.isForm ? _startProvinces[index] : _endProvinces[index]),
                  onTap: () {
                    Navigator.pop(context, widget.isForm ? _startProvinces[index] : _endProvinces[index]);
                  },
                );
              },
            ),
          ),
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
