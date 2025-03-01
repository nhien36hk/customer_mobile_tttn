import 'package:flutter/material.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/widgets/bottom_navigation_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            pages[pageIndex],
            Align(
              alignment: Alignment.bottomCenter, // Luôn ở dưới cùng
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BottomNavigationWidget(
                  onTabSelected: _onTabSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
