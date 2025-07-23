class MathQuestion {
  final int dividend;
  final int divisor;
  final int quotient;

  MathQuestion({required this.dividend, required this.divisor})
    : quotient = dividend ~/ divisor;

  String get questionText => '$dividend ÷ $divisor = ?';
  String get answerText => '$dividend ÷ $divisor = $quotient';

  bool get isValid => dividend % divisor == 0;
}
