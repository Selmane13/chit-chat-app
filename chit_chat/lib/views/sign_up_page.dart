import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/utils/Dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/show_custom_snackbar.dart';
import '../routes/route_helper.dart';

class SignUpPage extends GetView<UserController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    void _registration() {
      String name = nameController.text.trim();
      String password = passwordController.text.trim();
      String email = emailController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email address",
            title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address",
            title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than six chacarcters",
            title: "Password");
      } else {
        controller.signUp(name, password, email).then((status) {
          if (status) {
            print("Success registration");
            Get.toNamed(RouteHelper.getHomePage());
          } else {
            showCustomSnackBar("Already registered");
          }
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10 * 6),
              height: Dimensions.height10 * 7.5,
              width: Dimensions.height10 * 7.5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/message.png"),
                      fit: BoxFit.cover)),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              height: Dimensions.height10 * 5,
              width: Dimensions.height10 * 25,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/Chit Chat.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: Dimensions.height10 * 3,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(0.2))
                  ],
                  borderRadius:
                      BorderRadius.circular(Dimensions.height10 * 1.5)),
              child: TextField(
                obscureText: false,
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepPurple,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.height10 * 1.5),
                    )),
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(0.2))
                  ],
                  borderRadius:
                      BorderRadius.circular(Dimensions.height10 * 1.5)),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "password",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepPurple,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.height10 * 1.5),
                    )),
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(0.2))
                  ],
                  borderRadius:
                      BorderRadius.circular(Dimensions.height10 * 1.5)),
              child: TextField(
                obscureText: false,
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepPurple,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.height10 * 1.5),
                    )),
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            GestureDetector(
              onTap: () {
                _registration();
              },
              child: Container(
                width: Dimensions.height10 * 15,
                height: Dimensions.height10 * 6,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.height10 * 1.5),
                    color: Colors.deepPurple),
                child: Center(
                    child: Text(
                  "Sign up",
                  style: TextStyle(
                      fontSize: Dimensions.height10 * 1.7,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
            RichText(
                text: TextSpan(
                    text: "Have an account already?",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.back(),
                    style: TextStyle(color: Colors.grey[500], fontSize: 20))),
            SizedBox(
              height: Dimensions.height20,
            ),
            RichText(
                text: TextSpan(
                    text: "Sign up using one of the following methods",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16))),
            SizedBox(
              height: Dimensions.height10,
            ),
            Wrap(
              spacing: Dimensions.height10 * 5,
              children: [
                Container(
                  height: Dimensions.height10 * 5.5,
                  width: Dimensions.height10 * 5.5,
                  padding: EdgeInsets.all(Dimensions.height10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 0),
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2)
                      ],
                      borderRadius:
                          BorderRadius.circular(Dimensions.height10 * 1.5),
                      color: Colors.white),
                  child: Center(
                      child: Image.asset(
                    "assets/images/g.png",
                    fit: BoxFit.cover,
                  )),
                ),
                Container(
                    height: Dimensions.height10 * 5.5,
                    width: Dimensions.height10 * 5.5,
                    padding: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2)
                        ],
                        color: const Color(0xff0000ff),
                        borderRadius:
                            BorderRadius.circular(Dimensions.height10 * 1.5)),
                    child: Image.asset(
                      "assets/images/facebook.png",
                      fit: BoxFit.cover,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
