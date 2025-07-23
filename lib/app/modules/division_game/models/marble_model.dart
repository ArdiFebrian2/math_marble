// TODO Implement this library.
import 'package:flutter/material.dart';

class Marble {
  final String id;
  final Color color;
  bool isSelected;
  Offset? position;

  Marble({
    required this.id,
    this.color = Colors.deepPurple,
    this.isSelected = false,
    this.position,
  });

  Marble copyWith({String? id, Color? color, bool? isSelected}) {
    return Marble(
      id: id ?? this.id,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
      position: position ?? this.position,
    );
  }
}
