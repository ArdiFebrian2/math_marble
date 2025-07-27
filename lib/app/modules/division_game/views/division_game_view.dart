import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_marble/app/modules/division_game/controllers/division_game_controller.dart';
import '../widgets/marble_widget.dart';
import '../widgets/game_card_widget.dart';
import '../widgets/question_display.dart';

class DivisionGameView extends StatelessWidget {
  final DivisionGameController controller = Get.find<DivisionGameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SafeArea(
        child: Column(
          children: [
            // Question Display
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuestionDisplay(),
            ),
            const SizedBox(height: 10),

            // Game Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // Game Cards
                          SizedBox(
                            width: 120,
                            child: Obx(
                              () => ListView.builder(
                                itemCount: controller.gameCards.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: GameCardWidget(
                                      card: controller.gameCards[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Marble Area
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final maxWidth = constraints.maxWidth;
                                final maxHeight = constraints.maxHeight;

                                return Obx(() {
                                  return Stack(
                                    children: controller.availableMarbles.map((
                                      marble,
                                    ) {
                                      final position =
                                          marble.position ?? Offset.zero;

                                      final clampedX = position.dx.clamp(
                                        0.0,
                                        maxWidth - 35,
                                      ); // 35 = marble size
                                      final clampedY = position.dy.clamp(
                                        0.0,
                                        maxHeight - 35,
                                      );

                                      return Positioned(
                                        left: clampedX,
                                        top: clampedY,
                                        child: MarbleWidget(marble: marble),
                                      );
                                    }).toList(),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Check Answer Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Check Answer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
