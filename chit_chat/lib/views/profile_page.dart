import 'dart:io';

import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/routes/route_helper.dart';
import 'package:chit_chat/utils/account_widget.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/Dimensions.dart';

class ProfilePage extends GetView<UserController> {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Color(0xff8640DF),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4),
            ], color: Colors.white),
            child: Column(
              children: [
                GetBuilder<UserController>(builder: (_) {
                  return Container(
                      margin: EdgeInsets.only(top: Dimensions.height20),
                      height: Dimensions.height10 * 10,
                      width: Dimensions.height10 * 10,
                      child: (controller.userModel.img!.isEmpty)
                          ? controller.image == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.blueGrey[200],
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(controller.image!),
                                  backgroundColor: Colors.grey,
                                )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  AppConstants.BASE_URL +
                                      "/" +
                                      controller.userModel.img!),
                              backgroundColor: Colors.grey,
                            ));
                }),
                SizedBox(
                  height: Dimensions.height20,
                ),
                GestureDetector(
                  onTap: () async {
                    await controller.pickImage();
                  },
                  child: RichText(
                      text: const TextSpan(
                    text: "Edit photo",
                    style: TextStyle(
                        color: Color(0xff8640DF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  height: Dimensions.height20 * 1.5,
                )
              ],
            ),
          ),
          SizedBox(
            height: Dimensions.height10 / 2,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getEditPage(),
                  parameters: {"page": "Username"});
            },
            child: AccountWidget(
                icon: Icons.person, text: controller.userModel.username),
          ),
          GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getEditPage(),
                    parameters: {"page": "Email"});
              },
              child: AccountWidget(
                  icon: Icons.email, text: controller.userModel.email)),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getEditPage(),
                  parameters: {"page": "Phone"});
            },
            child: AccountWidget(
                icon: Icons.phone,
                text: controller.userModel.phone!.isEmpty
                    ? "Phone number"
                    : controller.userModel.phone!),
          ),
          AccountWidget(icon: Icons.lock_outline_rounded, text: "Password"),
          GestureDetector(
            onTap: () async {
              await controller.logout();
              Get.delete<ConversationController>();
              Get.offAndToNamed(RouteHelper.getSignInPage());
            },
            child: AccountWidget(
              icon: Icons.logout,
              text: "Logout",
              color: Color(0xffFF0000).withOpacity(0.51),
              textColor: Color(0xffFF0000),
            ),
          ),
        ],
      ),
    );
  }
}
