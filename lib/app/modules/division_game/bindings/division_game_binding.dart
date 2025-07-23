import 'package:get/get.dart';

import '../controllers/division_game_controller.dart';

class DivisionGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DivisionGameController>(
      () => DivisionGameController(),
    );
  }
}
