import 'package:attendance_system_app/repository/register_user/register.user.repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUserController extends GetxController {
  final registerFirstNameController = TextEditingController();
  final registerLastNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerFirstNameNode = FocusNode();
  final registerLastNameNode = FocusNode();
  final registerEmailNode = FocusNode();
  final registerPasswordNode = FocusNode();
  final registerConfirmPasswordNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterUserController();
  Rx<bool> isLoading = false.obs;
  Future userRegister(
      {required String? name,
      required String? email,
      required String password}) async {
    try {
      isLoading.value = true;
      final result = await RegisterUserRepo.registerUserRepo(
          name: name, email: email, password: password);
      isLoading.value = false;
      if (result.statusCode == 200) {
        isLoading.value = false;

        registerLastNameController.clear();
        registerEmailController.clear();
        registerFirstNameController.clear();
        registerConfirmPasswordController.clear();
        registerPasswordController.clear();
        Get.back();
        Get.snackbar("Message", result.message ?? "User Register Successfully",
            backgroundColor: Colors.orange);
      }
    } catch (e) {
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();
      isLoading.value = false;
      print(jsonPart.toString());
      Get.snackbar("Error", jsonPart.toString(),
          backgroundColor: Colors.orange);
    }
  }
}
