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

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> 
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  
  // Định nghĩa danh sách animations cho mỗi tab
  late List<Animation<double>> _scaleAnimations;
  
  // Định nghĩa các tab với icon và label
  final List<Map<String, dynamic>> _tabs = [
    {'icon': Iconsax.home, 'label': 'Trang chủ'},
    {'icon': Iconsax.ticket, 'label': 'Vé của tôi'},
    {'icon': IconlyLight.notification, 'label': 'Thông báo'},
    {'icon': Iconsax.user, 'label': 'Tài khoản'},
  ];

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Constants.animationDuration,
    );
    
    // Khởi tạo các animations cho mỗi tab
    _scaleAnimations = List.generate(
      _tabs.length,
      (index) => Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            (index * 0.2 + 0.3).clamp(0.0, 1.0),
            curve: Curves.elasticOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
      widget.onTabSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [Constants.mainShadow],
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _tabs.length,
                (index) => _buildNavItem(index),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildNavItem(int index) {
    final bool isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: isSelected ? _scaleAnimations[index].value : 1.0,
              child: Icon(
                _tabs[index]['icon'],
                color: isSelected 
                  ? Constants.backgroundColor 
                  : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: Constants.animationDuration,
              height: 5,
              width: isSelected ? 5 : 0,
              decoration: BoxDecoration(
                color: isSelected ? Constants.backgroundColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
