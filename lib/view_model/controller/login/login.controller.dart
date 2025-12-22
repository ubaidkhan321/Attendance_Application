import 'package:attendance_system_app/model/login.model.dart';
import 'package:attendance_system_app/repository/login/login.repo.dart';
import 'package:attendance_system_app/resource/routes/route.name.dart';
import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ProgressStatus { idle, loading, success, failure }

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isObscure = true.obs;
  Rx<ProgressStatus> progressStatus = ProgressStatus.idle.obs;
  LoginController();
  Rx<bool> isLoading = false.obs;

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  String? get emailText {
    final text = emailController.text;
    if (text.isEmpty) {
      return 'Email can\'t be empty';
    }
    return null;
  }

  String? get passwordText {
    final text = passwordController.text;
    if (text.isEmpty) {
      return 'Password can\'t be empty';
    }
    return null;
  }

  Future<LoginModel?> login(
      {required String userName,
      required String password,
      required BuildContext context}) async {
    try {
      progressStatus.value = ProgressStatus.loading;
      isLoading.value = true;
      await Future.delayed(Duration.zero);
      LoginModel response = await LoginRepository.loginRepo(userName, password);
      if (response.statusCode == 200) {
        isLoading.value = false;
        final session = SessionController.instance;
        session.setSession(response.data?.sId.toString(),
            response.data?.name.toString(), response.data?.type.toString());

        if (kDebugMode) {
          print(response.data?.sId);
        }
        progressStatus.value = ProgressStatus.success;
        Get.snackbar("Message", "Login SuccessFully",
            backgroundColor: Colors.orange);

        Get.toNamed(Routes.NAVBARSCREEN);
        emailController.clear();
        passwordController.clear();

        return response;
      } else {
        isLoading.value = false;
        progressStatus.value = ProgressStatus.failure;
        print("else ${response.message}");
        Get.snackbar('Login Failed', response.message ?? "Unknown error");
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      progressStatus.value = ProgressStatus.failure;
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();
      Get.snackbar("message", jsonPart, backgroundColor: Colors.orange);

      if (kDebugMode) {
        print("catch ${jsonPart.toString()}");
      }
      return null;
    }
  }
}
