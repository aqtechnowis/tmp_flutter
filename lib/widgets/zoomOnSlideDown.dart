import 'package:flutter/material.dart';

class ZoomOnSlideDownWidget extends StatefulWidget {
  final Widget child;

  ZoomOnSlideDownWidget({required this.child});

  @override
  _ZoomOnSlideDownWidgetState createState() => _ZoomOnSlideDownWidgetState();
}

class _ZoomOnSlideDownWidgetState extends State<ZoomOnSlideDownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _scale = 1.0;
  double _slideOffset = 0.0;
  double _maxSlideOffset = 100.0;
  double _maxScale = 1.6;
  double _initialScale = 1.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = Tween<double>(begin: 1.0, end: _maxScale).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _slideOffset += details.delta.dy;

      if (_slideOffset > _maxSlideOffset) {
        _slideOffset = _maxSlideOffset;
      } else if (_slideOffset < 0) {
        _slideOffset = 0;
      }

      _scale = 1.0 + (_slideOffset / _maxSlideOffset) * (_maxScale - 1.0);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_slideOffset > _maxSlideOffset * 0.5) {
      _animationController.forward().then((_) {
        setState(() {
          _initialScale = _maxScale;
          _slideOffset = _maxSlideOffset;
          _scale =
              _maxScale; // Set scale to the maximum value after animation completes
        });
      });
      _animationController.reset();
      _animationController.duration = const Duration(
          milliseconds: 700); // Reset the duration to the original value
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        setState(() {
          _initialScale = 1.0;
          _slideOffset = 0.0;
          _scale = 1.0;
        });
      });
    }

    // Reset the zoom when dragging stops
    if (_scale != 1.0) {
      _animationController.reverse().then((_) {
        setState(() {
          _initialScale = 1.0;
          _scale = 1.0;
          _slideOffset = 0.0;
        });
      });
      _animationController.reset();
      _animationController.duration = const Duration(
          milliseconds: 700); // Reset the duration to the original value
      _animationController.forward();
    }

    _animationController.reset();
    _animationController.duration = const Duration(
        milliseconds: 700); // Reset the duration to the original value
    _animationController.forward();
  }

  void _handleVerticalDragCancel() {
    setState(() {
      _scale = 1.0;
    });

    _animationController.reset();
    _animationController.duration = const Duration(
        milliseconds: 700); // Reset the duration to the original value
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleVerticalDragUpdate,
      onVerticalDragEnd: _handleVerticalDragEnd,
      onVerticalDragCancel: _handleVerticalDragCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale,
            alignment: Alignment.topLeft,
            child: widget.child,
          );
        },
      ),
    );
  }
}
