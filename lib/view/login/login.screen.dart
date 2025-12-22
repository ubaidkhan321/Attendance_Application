import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/resource/constant/constant.dart';
import 'package:attendance_system_app/utils/custom.button.dart';
import 'package:attendance_system_app/utils/custom_textfield.dart';
import 'package:attendance_system_app/view_model/controller/forgot.password.controller.dart/forgot.password.controller.dart';
import 'package:attendance_system_app/view_model/controller/login/login.controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var forgotcontroller = Get.find<FORGOTPASSWORDController>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          Assets.DISTRHO_LOGO,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (p0) {
                            return controller.emailText;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter User Name',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => CustomTextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.isObscure.value,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: (p0) {
                              return controller.passwordText;
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.togglePasswordVisibility();
                                    },
                                    icon: Icon(
                                      controller.isObscure.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    )),
                                hintText: 'Enter Password',
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              final formKey = GlobalKey<FormState>();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                      top: 20,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Reset Password",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller: forgotcontroller
                                                .emailController,
                                            decoration: InputDecoration(
                                              labelText: "Enter Email",
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter your Email";
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller:
                                                forgotcontroller.nameController,
                                            decoration: InputDecoration(
                                              labelText: "Enter Name",
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter your Name";
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => CustomButton(
                                                isLoading: forgotcontroller
                                                    .isLoading.value,
                                                buttonColor: Colors.blue,
                                                text: "submit",
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    forgotcontroller.forgotpassword(
                                                        name: forgotcontroller
                                                            .nameController
                                                            .text,
                                                        email: forgotcontroller
                                                            .emailController
                                                            .text);
                                                  }
                                                }),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: AppColors.themeColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(4, 8),
                  ),
                ],
              ),
              child: CustomButton(
                  buttonColor: const Color(0xFF1E88E5),
                  text: AppStrings.LOGIN,
                  isLoading:
                      controller.progressStatus.value == ProgressStatus.loading,
                  isSuccess:
                      controller.progressStatus.value == ProgressStatus.success,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.login(
                          userName: controller.emailController.text,
                          password: controller.passwordController.text,
                          context: context);
                    }
                  },
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18)),
            ),
          ),
          const SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
