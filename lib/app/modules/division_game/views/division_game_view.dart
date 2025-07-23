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
            // Question Display di atas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuestionDisplay(),
            ),

            const SizedBox(height: 10),

            // Expanded scrollable game area + tombol
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Game Area
                    Expanded(
                      child: Row(
                        children: [
                          // Kartu Game
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

                          // Marble Area dengan posisi acak (menggunakan Stack)
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
                                          marble.position ?? Offset(0, 0);
                                      // Clamp posisi agar tetap dalam batas
                                      final dx = position.dx.clamp(
                                        0.0,
                                        maxWidth - 30,
                                      );
                                      final dy = position.dy.clamp(
                                        0.0,
                                        maxHeight - 30,
                                      );

                                      return Positioned(
                                        left: dx,
                                        top: dy,
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

                    // Tombol Check Answer
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
