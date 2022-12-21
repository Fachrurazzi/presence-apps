import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_apps/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        isLoading.value = true;
        try {
          await auth.currentUser!.updatePassword(newPassC.text);

          String email = auth.currentUser!.email!;

          await auth.signOut();

          auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.LOGIN);
        } on FirebaseAuthException catch (e) {
          if (e.code == "weak-password") {
            Get.snackbar("Peringatan", "Password yang anda masukkan lemah");
          }
        } catch (e) {
          Get.snackbar("Peringatan", "Password yang anda masukkan salah");
        } finally {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Peringatan",
          "Password baru tidak boleh sama dengan password sebelumnya",
        );
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password Baru wajib diisi");
    }
  }
}
