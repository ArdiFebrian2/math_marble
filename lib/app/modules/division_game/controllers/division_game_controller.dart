import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/marble_model.dart';
import '../models/card_model.dart';
import '../models/math_question.dart';

class DivisionGameController extends GetxController {
  // Observable variables
  final RxList<Marble> availableMarbles = <Marble>[].obs;
  final RxList<GameCard> gameCards = <GameCard>[].obs;
  final Rx<MathQuestion> currentQuestion = MathQuestion(
    dividend: 24,
    divisor: 3,
  ).obs;
  final RxBool isGameComplete = false.obs;
  final RxString gameStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeGame();
  }

  void initializeGame() {
    final question = currentQuestion.value;
    availableMarbles.clear();

    const double marbleSize = 30.0;
    const double maxWidth = 300.0; // Lebar maksimal area marble
    const double maxHeight = 400.0; // Tinggi maksimal area marble
    const double padding = 8.0; // Jarak antar marble

    final random = Random();
    final List<Offset> positions = [];

    Offset generateNonOverlappingPosition() {
      int attempts = 0;
      while (attempts < 1000) {
        final dx = random.nextDouble() * (maxWidth - marbleSize);
        final dy = random.nextDouble() * (maxHeight - marbleSize);
        final candidate = Offset(dx, dy);

        bool overlaps = positions.any((existing) {
          final distance = (existing - candidate).distance;
          return distance < marbleSize + padding;
        });

        if (!overlaps) {
          positions.add(candidate);
          return candidate;
        }

        attempts++;
      }
      // Jika terlalu banyak marble dan tidak menemukan posisi bebas, tetap return
      return Offset(
        random.nextDouble() * (maxWidth - marbleSize),
        random.nextDouble() * (maxHeight - marbleSize),
      );
    }

    final List<Marble> marbles = List.generate(
      question.dividend,
      (i) => Marble(
        id: 'marble_$i',
        color: Colors.deepPurple,
        position: generateNonOverlappingPosition(),
      ),
    );

    availableMarbles.addAll(marbles);

    gameCards.value = [
      GameCard(type: CardType.red, color: Colors.orange),
      GameCard(type: CardType.yellow, color: Colors.yellow),
      GameCard(type: CardType.green, color: Colors.cyan),
    ];

    isGameComplete.value = false;
    gameStatus.value = '';
  }

  void onMarbleDraggedToCard(Marble marble, CardType cardType) {
    // Remove marble from available marbles
    availableMarbles.removeWhere((m) => m.id == marble.id);

    // Add marble to the target card
    final cardIndex = gameCards.indexWhere((card) => card.type == cardType);
    if (cardIndex != -1) {
      gameCards[cardIndex].marbles.add(marble);
      gameCards.refresh();
    }
  }

  void onMarbleRemovedFromCard(Marble marble) {
    // Remove marble from all cards and add back to available marbles
    for (var card in gameCards) {
      card.marbles.removeWhere((m) => m.id == marble.id);
    }
    availableMarbles.add(marble);
    gameCards.refresh();
  }

  void checkAnswer() {
    final expectedCount = currentQuestion.value.quotient;
    final List<String> incorrectCards = [];

    // Check each card
    for (var card in gameCards) {
      if (card.marbles.length != expectedCount) {
        incorrectCards.add(_getCardName(card.type));
      }
    }

    if (incorrectCards.isEmpty &&
        _getTotalMarblesInCards() == currentQuestion.value.dividend) {
      // Correct answer
      isGameComplete.value = true;
      gameStatus.value = 'Correct!';
      _showResultDialog(
        title: 'Correct!',
        message: 'Well done! Each group has exactly $expectedCount marbles.',
        isCorrect: true,
      );
    } else {
      // Incorrect answer
      String message = 'Incorrect answer.\n';
      if (incorrectCards.isNotEmpty) {
        message +=
            'Cards with wrong number of marbles: ${incorrectCards.join(', ')}\n';
      }
      message += 'Each group should have exactly $expectedCount marbles.';

      gameStatus.value = 'Try again!';
      _showResultDialog(
        title: 'Try Again!',
        message: message,
        isCorrect: false,
        incorrectCards: incorrectCards,
      );
    }
  }

  void resetGame() {
    initializeGame();
  }

  void newQuestion() {
    // Generate a new question (you can expand this logic)
    final questions = [
      MathQuestion(dividend: 24, divisor: 3),
      MathQuestion(dividend: 20, divisor: 4),
      MathQuestion(dividend: 18, divisor: 6),
      MathQuestion(dividend: 15, divisor: 5),
      MathQuestion(dividend: 12, divisor: 4),
    ];

    currentQuestion.value =
        questions[DateTime.now().millisecond % questions.length];
    initializeGame();
  }

  String _getCardName(CardType type) {
    switch (type) {
      case CardType.red:
        return 'Red';
      case CardType.yellow:
        return 'Yellow';
      case CardType.green:
        return 'Green';
    }
  }

  int _getTotalMarblesInCards() {
    return gameCards.fold(0, (total, card) => total + card.marbles.length);
  }

  void _showResultDialog({
    required String title,
    required String message,
    required bool isCorrect,
    List<String>? incorrectCards,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (incorrectCards != null && incorrectCards.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Incorrect cards:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...incorrectCards.map((card) => Text('• $card card')),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('OK')),
          if (isCorrect)
            TextButton(
              onPressed: () {
                Get.back();
                newQuestion();
              },
              child: Text('New Question'),
            ),
        ],
      ),
    );
  }
}
