import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/constant.dart';

class BottomNavigationWidget extends StatefulWidget {
  final Function(int) onTabSelected;

  const BottomNavigationWidget({super.key, required this.onTabSelected});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _onItemTapped(0),
                  icon: Icon(
                    Iconsax.home,
                    color: _selectedIndex == 0
                        ? Constants.backgroundColor
                        : Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.circle,
                  color: _selectedIndex == 0
                      ? Constants.backgroundColor
                      : Colors.white,
                  size: 5,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _onItemTapped(1),
                  icon: Icon(
                    Iconsax.ticket,
                    color: _selectedIndex == 1
                        ? Constants.backgroundColor
                        : Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.circle,
                  color: _selectedIndex == 1
                      ? Constants.backgroundColor
                      : Colors.white,
                  size: 5,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _onItemTapped(2),
                  icon: Icon(
                    IconlyLight.notification,
                    color: _selectedIndex == 2
                        ? Constants.backgroundColor
                        : Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.circle,
                  color: _selectedIndex == 2
                      ? Constants.backgroundColor
                      : Colors.white,
                  size: 5,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _onItemTapped(3),
                  icon: Icon(
                    Iconsax.user,
                    color: _selectedIndex == 3
                        ? Constants.backgroundColor
                        : Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.circle,
                  color: _selectedIndex == 3
                      ? Constants.backgroundColor
                      : Colors.white,
                  size: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
