// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_marble/app/modules/division_game/controllers/division_game_controller.dart';
import '../models/marble_model.dart';

class MarbleWidget extends StatelessWidget {
  final Marble marble;
  final DivisionGameController controller = Get.find<DivisionGameController>();

  MarbleWidget({Key? key, required this.marble}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Marble>(
      data: marble,
      feedback: _buildMarble(isDragging: true),
      childWhenDragging: _buildMarble(opacity: 0.3),
      child: _buildMarble(),
    );
  }

  Widget _buildMarble({bool isDragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: isDragging ? 35 : 30,
        height: isDragging ? 35 : 30,
        decoration: BoxDecoration(
          color: marble.color,
          shape: BoxShape.circle,
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
