import 'package:get/get.dart';

import '../modules/division_game/bindings/division_game_binding.dart';
import '../modules/division_game/views/division_game_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DIVISION_GAME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DIVISION_GAME,
      page: () => DivisionGameView(),
      binding: DivisionGameBinding(),
    ),
  ];
}
