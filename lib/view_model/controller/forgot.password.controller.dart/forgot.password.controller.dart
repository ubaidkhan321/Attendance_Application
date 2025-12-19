import 'package:attendance_system_app/repository/forgotpassword/forgotpassword.repo.dart';
import 'package:attendance_system_app/utils/custom.button.dart';
import 'package:attendance_system_app/utils/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FORGOTPASSWORDController extends GetxController {
  FORGOTPASSWORDController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final resetFormKey = GlobalKey<FormState>();
  List data = [].obs;

  Rx<bool> isLoading = false.obs;

  Future forgotpassword({String? name, String? email}) async {
    try {
      isLoading.value = true;
      final result = await ForgotpasswordRepository.forgotpassword(
          name: name, email: email);
      if (result.statusCode == 200) {
        isLoading.value = false;
        data = result.data ?? [];

        Get.snackbar("Success", "Reset token received");
        showResetDialog();
      } else {
        isLoading.value = false;

        Get.snackbar("Error", result.message ?? "Something went wrong");
      }
    } catch (e) {
      isLoading.value = false;
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();
      Get.snackbar("message", jsonPart,
          backgroundColor: Colors.orange, colorText: Colors.white);

      print(e.toString());
    }
  }

  Future newPassword(
      {required String? token, required String? newPassword}) async {
    try {
      final result =
          await ForgotpasswordRepository.newPassword(token, newPassword);
      isLoading.value = false;
      if (result.statusCode == 200) {
        Get.back();

        Get.snackbar("Message", result.data ?? "");
      } else {
        isLoading.value = false;

        Get.snackbar("Error", result.message ?? "");
      }
    } catch (e) {
      isLoading.value = false;

      print(e.toString());
    }
  }

  void showResetDialog() {
    tokenController.text = data.isNotEmpty ? data[0] : "";

    Get.defaultDialog(
      barrierDismissible: false,
      title: "Reset Your Password",
      content: Form(
        key: resetFormKey,
        child: Column(
          children: [
            CustomTextFormField(
              decoration: InputDecoration(
                  labelText: "Token", border: OutlineInputBorder()),
              controller: tokenController,
              validator: (value) =>
                  value!.isEmpty ? "Token can't be Empty" : null,
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              decoration: InputDecoration(
                  labelText: "New Password", border: OutlineInputBorder()),
              controller: newPasswordController,
              validator: (value) =>
                  value!.isEmpty ? "Enter new password" : null,
            ),
            SizedBox(height: 20),
            CustomButton(
                buttonColor: Colors.blue,
                isLoading: isLoading.value,
                text: "Reset Password",
                onPressed: () {
                  newPassword(
                      token: tokenController.text,
                      newPassword: newPasswordController.text);
                })
          ],
        ),
      ),
    );
  }
}
