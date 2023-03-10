import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nameC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print(image!.name);
      print(image!.name.split('.').last);
      print(image!.path);
    } else {
      print(image);
    }

    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nameC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split('.').last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({
            "profile": urlImage,
          });
        }
        await firestore.collection("employees").doc(uid).update(data);
        image = null;
        Get.snackbar("Berhasil", "Profil berhasil diupdate");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat memperbarui profile");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Peringatan", "Nip, Email, Name wajib diisi");
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("employees").doc(uid).update(
        {
          "profile": FieldValue.delete(),
        },
      );

      Get.back();
      Get.snackbar("Berhasil", "foto profil berhasil di hapus");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "foto profil tidak dapat diupdate");
    } finally {
      update();
    }
  }
}
