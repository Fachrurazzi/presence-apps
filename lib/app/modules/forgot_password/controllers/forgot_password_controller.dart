import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);

        Get.snackbar("Succeed",
            "We have sent you a password reset email. Please check your email.");
      } catch (e) {
        Get.snackbar("Error", "password reset email cannot be sent ");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "A password reset email is required.");
    }
  }
}
