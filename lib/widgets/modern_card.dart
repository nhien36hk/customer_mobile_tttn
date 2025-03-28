import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final double borderRadius;
  final BoxShadow? shadow;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool enableAnimation;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const ModernCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 16,
    this.shadow,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.enableAnimation = true,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _controller = AnimationController(
        duration: Constants.animationDuration,
        vsync: this,
      );

      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enableAnimation && widget.onTap != null) {
      _controller.forward();
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enableAnimation && widget.onTap != null) {
      _controller.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onTapCancel() {
    if (widget.enableAnimation && widget.onTap != null) {
      _controller.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
      color: widget.backgroundColor ?? Colors.white,
      gradient: widget.gradient,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: [
        widget.shadow ??
            BoxShadow(
              color: Constants.backgroundColor.withOpacity(_isPressed ? 0.1 : 0.2),
              blurRadius: _isPressed ? 5 : 10,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
      ],
    );

    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: decoration,
      child: widget.child,
    );

    if (!widget.enableAnimation || widget.onTap == null) {
      return Container(
        margin: widget.margin,
        child: cardContent,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin,
              child: cardContent,
            ),
          );
        },
      ),
    );
  }
} 