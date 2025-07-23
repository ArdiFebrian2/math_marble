import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:math_marble/app/modules/division_game/controllers/division_game_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DivisionGameController());
  }
}
