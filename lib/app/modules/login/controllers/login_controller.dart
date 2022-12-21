import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_apps/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "Verifikasi email kamu",
                middleText: "Harap verifikasi terlebih dahulu email anda",
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar("Verifikasi email anda",
                            "Verifikasi telah terkirim ke email anda");
                        isLoading.value = false;
                      } catch (e) {
                        Get.snackbar("Peringatan",
                            "Email anda tidak dapat diverifikasi");
                        isLoading.value = false;
                      }
                    },
                    child: Text("Verifikasi Email"),
                  )
                ]);
          }
        }

        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Peringatan", "Email anda tidak ditemukan");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Peringatan", "Password yang anda masukkan salah");
        }
      } catch (e) {
        Get.snackbar("Login Gagal", "Belum berhasil login ${emailC.text}");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib diisi");
    }
  }
}
