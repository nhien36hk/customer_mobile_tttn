import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/main.dart';
import 'package:gotta_go/widgets/bottom_navigation_widget.dart';
import 'package:gotta_go/widgets/gradient_background.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
  
  // Thêm phương thức public để chuyển tab
  static void switchToTab(int index) {
    final state = layoutScreenKey.currentState as _LayoutScreenState?;
    if (state != null) {
      state._onTabSelected(index);
    }
  }
}

class _LayoutScreenState extends State<LayoutScreen> with TickerProviderStateMixin {
  int pageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _pageController = PageController(initialPage: pageIndex);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (index != pageIndex) {
      _animationController.reverse().then((_) {
        setState(() {
          pageIndex = index;
        });
        _pageController.jumpToPage(index);
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Hiệu ứng fade transition giữa các màn hình
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                ),
              ),
              // Bottom navigation bar
              Align(
                alignment: Alignment.bottomCenter,
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
      ),
    );
  }
}
