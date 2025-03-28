import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/widgets/modern_card.dart';
import 'package:gotta_go/widgets/gradient_button.dart';

class WarningWidget extends StatefulWidget {
  final Color colorInfor;
  final String textWarning;
  final VoidCallback? onConfirm;

  const WarningWidget({
    super.key, 
    required this.colorInfor, 
    required this.textWarning,
    this.onConfirm,
  });

  @override
  State<WarningWidget> createState() => _WarningWidgetState();
}

class _WarningWidgetState extends State<WarningWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ModernCard(
                padding: const EdgeInsets.all(24),
                borderRadius: 25,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Container với hiệu ứng pulse
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.colorInfor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 40,
                        color: widget.colorInfor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Text Warning
                    Text(
                      widget.textWarning,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Button
                    GradientButton(
                      text: "Đồng ý",
                      onPressed: () {
                        _controller.reverse().then((_) {
                          Navigator.pop(context);
                          if (widget.onConfirm != null) {
                            widget.onConfirm!();
                          }
                        });
                      },
                      height: 55,
                      borderRadius: 35,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
