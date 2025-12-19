import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/view_model/controller/splash/splash.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.DISTRHO_LOGO,
          width: double.maxFinite,
          height: 200,
        ),
      ),
    );
  }
}
