// lib/app/modules/division_game/models/card_model.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'marble_model.dart';

enum CardType { red, yellow, green }

class GameCard {
  final CardType type;
  final Color color;
  final RxList<Marble> marbles;

  GameCard({required this.type, required this.color, List<Marble>? marbles})
    : marbles = (marbles ?? []).obs;

  GameCard copyWith({CardType? type, Color? color, List<Marble>? marbles}) {
    return GameCard(
      type: type ?? this.type,
      color: color ?? this.color,
      marbles: marbles ?? this.marbles.toList(),
    );
  }
}
