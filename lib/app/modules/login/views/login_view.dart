import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_apps/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          TextField(
            controller: controller.emailC,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Obx(
            () => TextField(
              controller: controller.passC,
              autocorrect: false,
              obscureText: controller.isHidden.value,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHidden.toggle(),
                  icon: controller.isHidden.isFalse
                      ? Icon(Icons.remove_red_eye)
                      : Icon(Icons.remove_red_eye_outlined),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? "Login" : "Loading..."),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.FORGOT_PASSWORD);
            },
            child: Text("Lupa Password ?"),
          ),
        ],
      ),
    );
  }
}
