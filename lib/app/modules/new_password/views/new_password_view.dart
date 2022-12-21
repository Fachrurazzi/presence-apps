import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          Obx(
            () => TextField(
              controller: controller.newPassC,
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: controller.isHidden.value,
              decoration: InputDecoration(
                labelText: "New Password",
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
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.newPassword();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "New Password" : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
