import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/views/sign_up_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/show_custom_snackbar.dart';
import '../routes/route_helper.dart';
import '../utils/Dimensions.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void _login() async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showCustomSnackBar("Connection problem",
            title: "No internet connection");
      } else {
        String password = passwordController.text.trim();
        String email = emailController.text.trim();

        if (email.isEmpty) {
          showCustomSnackBar("Type in your email address",
              title: "Email address");
        } else if (!GetUtils.isEmail(email)) {
          showCustomSnackBar("Type in a valid email address",
              title: "Valid email address");
        } else if (password.isEmpty) {
          showCustomSnackBar("Type in your password", title: "Password");
        } else if (password.length < 0) {
          showCustomSnackBar("Password can not be less than six chacarcters",
              title: "Password");
        } else {
          Get.find<UserController>().signIn(email, password).then((status) {
            if (status) {
              Get.put(ConversationController(conversationRepo: Get.find()));
              Get.offAndToNamed(RouteHelper.getHomePage());
            } else {
              showCustomSnackBar("Wrong credentials");
            }
          });
        }
      }
    }

    return Scaffold(
      body: GetBuilder<UserController>(
        builder: (_userController) {
          return _userController.isLoading
              ? Dialog(
                  child: Container(
                      height: Dimensions.height10 * 5,
                      width: Dimensions.height10 * 5,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurple))),
                )
              : Container(
                  margin: EdgeInsets.only(top: Dimensions.height10 * 12),
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: Dimensions.height10 * 10,
                          width: Dimensions.height10 * 10,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/message.png"),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimensions.height10),
                          height: Dimensions.height10 * 5,
                          width: Dimensions.height10 * 25,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/Chit Chat.png"),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 3,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Dimensions.height20),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello",
                                style: TextStyle(
                                    fontSize: Dimensions.height10 * 6,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Sign into your account",
                                style: TextStyle(
                                    fontSize: Dimensions.height20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.height20,
                              right: Dimensions.height20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 1),
                                    color: Colors.grey.withOpacity(0.2))
                              ],
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5)),
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
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10 * 1.5),
                                    borderSide: const BorderSide(
                                        width: 1.0, color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10 * 1.5),
                                    borderSide: const BorderSide(
                                        width: 1.0, color: Colors.white)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height10 * 1.5),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.height20,
                              right: Dimensions.height20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 1),
                                    color: Colors.grey.withOpacity(0.2))
                              ],
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5)),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                hintText: "password",
                                prefixIcon: const Icon(
                                  Icons.password_rounded,
                                  color: Colors.deepPurple,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10 * 1.5),
                                    borderSide: const BorderSide(
                                        width: 1.0, color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10 * 1.5),
                                    borderSide: const BorderSide(
                                        width: 1.0, color: Colors.white)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height10 * 1.5),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height20 * 2,
                        ),
                        Container(
                          width: Dimensions.height10 * 15,
                          height: Dimensions.height10 * 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5),
                              color: Colors.deepPurple),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                _login();
                              },
                              child: Container(
                                width: Dimensions.height10 * 15,
                                height: Dimensions.height10 * 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height10 * 1.5),
                                    color: Colors.transparent),
                                child: Center(
                                    child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                      fontSize: Dimensions.height10 * 1.7,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        RichText(
                            text: TextSpan(
                                text: "Don't have an account ?",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: Dimensions.height20),
                                children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => SignUpPage(),
                                      transition: Transition.fade),
                                text: " Create",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.height20),
                              )
                            ])),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
