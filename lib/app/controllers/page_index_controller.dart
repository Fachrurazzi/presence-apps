import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_apps/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> response = await determinePosition();
        if (response["error"] != true) {
          Position position = response["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          String address =
              "${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}";

          double distance = Geolocator.distanceBetween(
              -2.966595, 115.1490433, position.latitude, position.longitude);

          await updatePosition(position, address);

          await presence(position, address, distance);

          // Get.snackbar(
          //   "Success",
          //   "Kamu telah absensi",
          // );
        } else {
          Get.snackbar("Terjadi Kesalahan", response["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presence(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("employees").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di Luar Area";

    if (distance <= 200) {
      status = "Di dalam Area";
    }

    if (snapPresence.docs.length == 0) {
      await Get.defaultDialog(
        title: "Selamat Datang :)",
        middleText:
            "Silahkan absen terlebih dahulu sebelum memulai pekerjaan :)",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              colPresence.doc(todayDocID).set(
                {
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                },
              );

              Get.back();
              Get.snackbar("Berhasil", "Selamat Bekerja :)");
            },
            child: Text("Absen"),
          )
        ],
      );
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();
      if (todayDoc.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();

        if (dataPresenceToday?["keluar"] != null) {
          Get.snackbar(
              "Terima Kasih :)", "Kamu telah melakukan absen sebelumnya :)");
        } else {
          await Get.defaultDialog(
            title: "Selamat Pulang :)",
            middleText: "Silahkan absen terlebih dahulu sebelum pulang :)",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  colPresence.doc(todayDocID).update(
                    {
                      "date": now.toIso8601String(),
                      "keluar": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    },
                  );

                  Get.back();
                  Get.snackbar("Berhasil",
                      "Terima kasih sudah bekerja, Hati-hati di jalan :)");
                },
                child: Text("Absen"),
              )
            ],
          );
        }
      } else {
        await Get.defaultDialog(
          title: "Selamat Pagi :)",
          middleText:
              "Silahkan absen terlebih dahulu sebelum memulai pekerjaan :)",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                colPresence.doc(todayDocID).set(
                  {
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  },
                );

                Get.back();
                Get.snackbar("Berhasil", "Selamat Bekerja :)");
              },
              child: Text("Absen"),
            )
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection("employees").doc(uid).update(
      {
        "position": {
          "lat": position.latitude,
          "long": position.longitude,
        },
        "address": address,
      },
    );
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "Layanan lokasi dinonaktifkan.",
        "error": true,
      };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return {
          "message": "Izin lokasi ditolak",
          "error": true,
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "position": position,
      "message": "berhasil mendapatkan koordinat lintang dan bujur",
      "error": false,
    };
  }
}
