// ignore_for_file: unused_element

import 'package:attendance_system_app/utils/custom.button.dart';
import 'package:attendance_system_app/utils/custom_textfield.dart';
import 'package:attendance_system_app/view_model/controller/registeruser/register.user.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void userRegister(BuildContext context) {
  var registercontroller = Get.put(RegisterUserController());
  final isPasswordObscure = true.obs;
  Rx<bool> isConfirmObscure = true.obs;

  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Register Account',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 25),
            Form(
              key: registercontroller.formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: registercontroller.registerFirstNameController,
                    focusNode: registercontroller.registerFirstNameNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(registercontroller.registerLastNameNode),
                    decoration: const InputDecoration(
                      hintText: 'Enter First Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "First Name is Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: registercontroller.registerLastNameController,
                    focusNode: registercontroller.registerLastNameNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(registercontroller.registerEmailNode),
                    decoration: const InputDecoration(
                      hintText: 'Enter Last Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Last Name is Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: registercontroller.registerEmailController,
                    focusNode: registercontroller.registerEmailNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(registercontroller.registerPasswordNode),
                    decoration: const InputDecoration(
                      hintText: 'Enter Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email Address is Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Obx(() => CustomTextFormField(
                        controller:
                            registercontroller.registerPasswordController,
                        focusNode: registercontroller.registerPasswordNode,
                        obscureText: isPasswordObscure.value,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPasswordObscure.value =
                                  !isPasswordObscure.value;
                            },
                            icon: Icon(
                              isPasswordObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue,
                            ),
                          ),
                          hintText: 'Enter Password',
                        ),
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(
                                registercontroller.registerConfirmPasswordNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is Required";
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 15),
                  Obx(() => CustomTextFormField(
                        controller: registercontroller
                            .registerConfirmPasswordController,
                        focusNode:
                            registercontroller.registerConfirmPasswordNode,
                        obscureText: isConfirmObscure.value,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              isConfirmObscure.value = !isConfirmObscure.value;
                            },
                            icon: Icon(
                              isConfirmObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue,
                            ),
                          ),
                          hintText: 'Enter Confirm Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirm password is Required";
                          } else if (value !=
                              registercontroller
                                  .registerPasswordController.text) {
                            return "Confirm Password are not match";
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 25),
                  Obx(
                    () => CustomButton(
                      isLoading: registercontroller.isLoading.value,
                      buttonColor: Colors.blue,
                      text: 'Register',
                      onPressed: () {
                        if (registercontroller.formKey.currentState!
                            .validate()) {
                          registercontroller.userRegister(
                              name:
                                  "${registercontroller.registerFirstNameController.text} ${registercontroller.registerLastNameController.text}",
                              email: registercontroller
                                  .registerEmailController.text,
                              password: registercontroller
                                  .registerPasswordController.text);
                          print(
                              "${registercontroller.registerFirstNameController.text} ${registercontroller.registerLastNameController.text}");
                          print(
                              registercontroller.registerEmailController.text);
                          print(registercontroller
                              .registerPasswordController.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  void showDialogBox(BuildContext context, Function onYesTap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are You Sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                await onYesTap();
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

void showDialogBox(BuildContext context, Function onYesTap) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are You Sure?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () async {
              await onYesTap();
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}
