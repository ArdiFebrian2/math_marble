import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_marble/app/modules/division_game/controllers/division_game_controller.dart';

class QuestionDisplay extends StatelessWidget {
  final DivisionGameController controller = Get.find<DivisionGameController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFCC67C2),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Text(
            'Find the result of the division',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 300,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A3EB1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Obx(
                        () => Text(
                          controller.currentQuestion.value.questionText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F206E),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Text(
                    '=',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
