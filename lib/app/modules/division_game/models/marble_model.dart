// TODO Implement this library.
import 'package:flutter/material.dart';

// ✅ marble_model.dart
class Marble {
  final String id;
  final Color color;
  final Offset position; // NON-NULLABLE
  final bool isMerged;
  double size;

  Marble({
    required this.id,
    required this.color,
    required this.position,
    this.isMerged = false,
    this.size = 50.0,
  });
}
