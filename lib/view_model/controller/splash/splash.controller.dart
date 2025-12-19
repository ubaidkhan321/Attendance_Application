import 'dart:async';
import 'package:attendance_system_app/resource/routes/route.name.dart';
import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSession();
    });
  }

  Timer? _timer;
  Future<void> _loadSession() async {
    final session = SessionController.instance;
    await session.loadSession();
    session
        .loadSession()
        .then((value) => _timer = Timer(const Duration(seconds: 3), () {
              final userId = session.userSession.data?.sId;

              if (userId != null) {
                Get.offAllNamed(Routes.NAVBARSCREEN);
              } else {
                Get.offAllNamed(Routes.LOGIN);
              }
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
