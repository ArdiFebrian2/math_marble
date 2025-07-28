import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/marble_model.dart';

class MarbleWidget extends StatefulWidget {
  final Marble marble;

  const MarbleWidget({Key? key, required this.marble}) : super(key: key);

  @override
  State<MarbleWidget> createState() => _MarbleWidgetState();
}

class _MarbleWidgetState extends State<MarbleWidget>
    with TickerProviderStateMixin {
  AnimationController? _scaleController;
  AnimationController? _glowController;
  AnimationController? _rotationController;
  AnimationController? _bounceController;
  AnimationController? _pulseController;
  AnimationController? _floatController;
  AnimationController? _driftController;
  AnimationController? _orbitalController;

  Animation<double>? _scaleAnimation;
  Animation<double>? _glowAnimation;
  Animation<double>? _rotationAnimation;
  Animation<double>? _bounceAnimation;
  Animation<double>? _pulseAnimation;
  Animation<double>? _floatAnimation;
  Animation<Offset>? _driftAnimation;
  Animation<double>? _orbitalAnimation;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    try {
      _initializeAnimations();
      _startMovementAnimations();

      if (widget.marble.isMerged) {
        _playMergeAnimation();
      }
    } catch (e) {
      debugPrint('Error initializing MarbleWidget animations: $e');
    }
  }

  void _initializeAnimations() {
    // Scale animation untuk merge effect
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _scaleController!, curve: Curves.elasticOut),
    );

    // Glow animation untuk highlight effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController!, curve: Curves.easeInOut),
    );

    // Rotation animation untuk spinning effect
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController!, curve: Curves.linear),
    );

    // Bounce animation untuk entrance effect
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController!, curve: Curves.bounceOut),
    );

    // Pulse animation untuk idle state
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );

    // Float animation - gerakan naik turun
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController!, curve: Curves.easeInOut),
    );

    // Drift animation - gerakan horizontal halus
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _driftAnimation =
        Tween<Offset>(
          begin: const Offset(-5.0, 0.0),
          end: const Offset(5.0, 0.0),
        ).animate(
          CurvedAnimation(parent: _driftController!, curve: Curves.easeInOut),
        );

    // Orbital animation - gerakan melingkar
    _orbitalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    _orbitalAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbitalController!, curve: Curves.linear),
    );
  }

  void _startMovementAnimations() {
    // Start entrance animation
    _bounceController?.forward();

    // Start continuous movement animations
    _floatController?.repeat(reverse: true);
    _driftController?.repeat(reverse: true);
    _orbitalController?.repeat();
    _rotationController?.repeat();
    _pulseController?.repeat(reverse: true);
  }

  void _stopMovementAnimations() {
    _floatController?.stop();
    _driftController?.stop();
    _orbitalController?.stop();
    _rotationController?.stop();
    _pulseController?.stop();
  }

  void _playMergeAnimation() {
    _scaleController?.forward().then((_) {
      _scaleController?.reverse();
      _glowController?.forward().then((_) {
        _glowController?.reverse();
      });
    });
  }

  @override
  void didUpdateWidget(covariant MarbleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.marble.isMerged && !oldWidget.marble.isMerged) {
      _playMergeAnimation();
    }
  }

  @override
  void dispose() {
    _scaleController?.dispose();
    _glowController?.dispose();
    _rotationController?.dispose();
    _bounceController?.dispose();
    _pulseController?.dispose();
    _floatController?.dispose();
    _driftController?.dispose();
    _orbitalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Marble>(
      data: widget.marble,
      feedback: _buildMarble(isDragging: true),
      childWhenDragging: _buildMarble(opacity: 0.3),
      child: _buildAnimatedMarble(),
      onDragStarted: () {
        _isDragging = true;
        _stopMovementAnimations();
      },
      onDragEnd: (details) {
        _isDragging = false;
        _startMovementAnimations();
      },
    );
  }

  Widget _buildAnimatedMarble() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation ?? const AlwaysStoppedAnimation(1.0),
        _glowAnimation ?? const AlwaysStoppedAnimation(0.0),
        _rotationAnimation ?? const AlwaysStoppedAnimation(0.0),
        _bounceAnimation ?? const AlwaysStoppedAnimation(1.0),
        _pulseAnimation ?? const AlwaysStoppedAnimation(1.0),
        _floatAnimation ?? const AlwaysStoppedAnimation(0.0),
        _driftAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
        _orbitalAnimation ?? const AlwaysStoppedAnimation(0.0),
      ]),
      builder: (context, child) {
        final scaleValue =
            (_bounceAnimation?.value ?? 1.0) *
            (_scaleAnimation?.value ?? 1.0) *
            (_pulseAnimation?.value ?? 1.0);
        final rotationValue = _rotationAnimation?.value ?? 0.0;
        final glowValue = _glowAnimation?.value ?? 0.0;
        final floatValue = _floatAnimation?.value ?? 0.0;
        final driftValue = _driftAnimation?.value ?? Offset.zero;
        final orbitalValue = _orbitalAnimation?.value ?? 0.0;

        // Calculate orbital movement
        final orbitalRadius = 3.0;
        final orbitalOffset = Offset(
          math.cos(orbitalValue) * orbitalRadius,
          math.sin(orbitalValue) * orbitalRadius,
        );

        // Combine all movement effects
        final totalOffset = Offset(
          driftValue.dx + orbitalOffset.dx,
          floatValue + driftValue.dy + orbitalOffset.dy,
        );

        return Transform.translate(
          offset: _isDragging ? Offset.zero : totalOffset,
          child: Transform.scale(
            scale: scaleValue,
            child: Transform.rotate(
              angle: rotationValue,
              child: _buildMarble(glowIntensity: glowValue),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarble({
    bool isDragging = false,
    double opacity = 1.0,
    double glowIntensity = 0.0,
  }) {
    final size = isDragging ? 35.0 : 30.0;

    return Opacity(
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.marble.color.withOpacity(0.8),
              widget.marble.color,
              widget.marble.color.withOpacity(0.9),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          boxShadow: [
            // Base shadow yang mengikuti gerakan
            BoxShadow(
              color: Colors.black26,
              blurRadius: isDragging ? 12 : 6,
              offset: Offset(isDragging ? 3 : 1, isDragging ? 3 : 2),
            ),
            // Glow effect
            if (glowIntensity > 0.0)
              BoxShadow(
                color: widget.marble.color.withOpacity(glowIntensity * 0.6),
                blurRadius: 20 * glowIntensity,
                spreadRadius: 5 * glowIntensity,
              ),
            // Inner highlight
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(-1, -1),
            ),
            // Motion blur effect saat bergerak
            if (!_isDragging)
              BoxShadow(
                color: widget.marble.color.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.4), Colors.transparent],
              stops: const [0.0, 0.6],
            ),
          ),
        ),
      ),
    );
  }
}
