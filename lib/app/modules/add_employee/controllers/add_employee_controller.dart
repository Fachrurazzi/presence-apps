import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddEmployee = false.obs;
  RxBool isHidden = true.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> processAddEmployee() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddEmployee.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential adminCredential = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential employeeCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (employeeCredential.user != null) {
          String uid = auth.currentUser!.uid;

          await firestore.collection("employees").doc(uid).set(
            {
              "nip": nipC.text,
              "name": nameC.text,
              "job": jobC.text,
              "email": emailC.text,
              "uid": uid,
              "createdAt": DateTime.now().toIso8601String(),
            },
          );
          await employeeCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential adminCredential =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Karyawan ditambahkan");
        }

        isLoadingAddEmployee.value = false;
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          Get.snackbar("Peringatan", "Password minimal 6 karakter");
        } else if (e.code == "email-already-in-use") {
          Get.snackbar("Peringatan", "Email sudah pernah digunakan");
        } else if (e.code == "wrong-password") {
          Get.snackbar("Peringatan", "Password yang dimasukkan salah");
        } else {
          Get.snackbar("Terjadi Kesalahan", "$e");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan karyawan");
      } finally {
        isLoadingAddEmployee.value = false;
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Password tidak boleh kosong",
      );
    }
  }

  void addEmployee() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      Get.defaultDialog(
        title: "Konfirmasi",
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Masukkan password untuk konfirmasi validasi"),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => TextField(
                  controller: passAdminC,
                  autocorrect: false,
                  obscureText: isHidden.value,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => isHidden.toggle(),
                      icon: isHidden.isFalse
                          ? Icon(Icons.remove_red_eye)
                          : Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Get.back();
              isLoading.value = false;
            },
            child: Text("Batal"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAddEmployee.isFalse) {
                  await processAddEmployee();
                }
                isLoading.value = false;
              },
              child:
                  Text(isLoadingAddEmployee.isFalse ? "Tambah" : "Loading..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "Nip, Nama, Jabatan, Email wajib diisi");
    }
  }
}
