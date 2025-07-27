import 'package:flutter/material.dart';
import '../models/marble_model.dart';

class MarbleWidget extends StatefulWidget {
  final Marble marble;

  const MarbleWidget({Key? key, required this.marble}) : super(key: key);

  @override
  State<MarbleWidget> createState() => _MarbleWidgetState();
}

class _MarbleWidgetState extends State<MarbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.marble.isMerged) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void didUpdateWidget(covariant MarbleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.marble.isMerged && !oldWidget.marble.isMerged) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Marble>(
      data: widget.marble,
      feedback: _buildMarble(isDragging: true),
      childWhenDragging: _buildMarble(opacity: 0.3),
      child: _buildAnimatedMarble(),
    );
  }

  Widget _buildAnimatedMarble() {
    return ScaleTransition(scale: _scaleAnimation, child: _buildMarble());
  }

  Widget _buildMarble({bool isDragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isDragging ? 35 : 30,
        height: isDragging ? 35 : 30,
        decoration: BoxDecoration(
          color: widget.marble.color,
          shape: BoxShape.circle,
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
