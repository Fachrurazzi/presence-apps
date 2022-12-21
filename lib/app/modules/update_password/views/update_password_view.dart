import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          Obx(
            () => TextField(
              controller: controller.oldC,
              autocorrect: false,
              obscureText: controller.isHiddenOld.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Old Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHiddenOld.toggle(),
                  icon: controller.isHiddenOld.isFalse
                      ? Icon(Icons.remove_red_eye)
                      : Icon(
                          Icons.remove_red_eye_outlined,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => TextField(
              controller: controller.newC,
              autocorrect: false,
              obscureText: controller.isHiddenNew.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHiddenNew.toggle(),
                  icon: controller.isHiddenNew.isFalse
                      ? Icon(Icons.remove_red_eye)
                      : Icon(
                          Icons.remove_red_eye_outlined,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => TextField(
              controller: controller.confirmC,
              autocorrect: false,
              obscureText: controller.isHiddenConfirm.value,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHiddenConfirm.toggle(),
                  icon: controller.isHiddenConfirm.isFalse
                      ? Icon(Icons.remove_red_eye)
                      : Icon(
                          Icons.remove_red_eye_outlined,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePassword();
                }
              },
              child: Text(
                controller.isLoading.isFalse ? "Update Password" : "Loading...",
              ),
            ),
          )
        ],
      ),
    );
  }
}
