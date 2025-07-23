import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_marble/app/modules/division_game/controllers/division_game_controller.dart';
import '../models/card_model.dart';
import '../models/marble_model.dart';

class GameCardWidget extends StatelessWidget {
  final GameCard card;
  final DivisionGameController controller = Get.find<DivisionGameController>();

  GameCardWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Half visible card
        Align(
          alignment: Alignment.centerLeft,
          child: DragTarget<Marble>(
            onAccept: (marble) {
              controller.onMarbleDraggedToCard(marble, card.type);
            },
            builder: (context, candidateData, rejectedData) {
              final isHighlighted = candidateData.isNotEmpty;

              return Container(
                width: 60, // Only half width shown
                height: 140,
                decoration: BoxDecoration(
                  color: card.color.withOpacity(isHighlighted ? 0.8 : 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHighlighted ? Colors.white : card.color,
                    width: isHighlighted ? 3 : 1,
                  ),
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: card.color.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: card.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
        ),

        // Marbles outside the card (on the right side)
        Expanded(
          child: Obx(
            () => Wrap(
              spacing: 4,
              runSpacing: 4,
              children: card.marbles.map((marble) {
                return GestureDetector(
                  onTap: () => controller.onMarbleRemovedFromCard(marble),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: marble.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
