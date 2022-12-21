import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHiddenOld = true.obs;
  RxBool isHiddenNew = true.obs;
  RxBool isHiddenConfirm = true.obs;

  TextEditingController oldC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (oldC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
            email: emailUser,
            password: oldC.text,
          );

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();

          Get.snackbar("Berhasil", "Password berhasil diupdate");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Peringatan", "Password yang anda masukkan salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat memperbarui password");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Peringatan", "Password konfirmasi tidak sama");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Old Password, New Password, Confirm Password wajib diisi");
    }
  }
}
