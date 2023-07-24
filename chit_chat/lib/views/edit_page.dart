import 'package:chit_chat/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/Dimensions.dart';

class EditPage extends GetView<UserController> {
  String page;
  EditPage({super.key, required this.page});

  var textController = TextEditingController();

  void _save() {
    switch (page) {
      case "Username":
        controller.editUsername(textController.text);
        break;

      case "Email":
        controller.editEmail(textController.text);
        break;
      case "Phone":
        controller.editPhone(textController.text);
        break;
      case "Pssword":
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit " + page),
        centerTitle: true,
        backgroundColor: Color(0xff8640DF),
      ),
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(
              left: Dimensions.height20,
              right: Dimensions.height20,
              top: Dimensions.height10 * 5),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                    color: Colors.grey.withOpacity(0.2))
              ],
              borderRadius: BorderRadius.circular(Dimensions.height10 * 1.5)),
          child: TextField(
            obscureText: false,
            controller: textController,
            decoration: InputDecoration(
                hintText: page,
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
          height: Dimensions.height10 * 3,
        ),
        GestureDetector(
          onTap: () {
            _save();
            Get.back();
          },
          child: Container(
            width: Dimensions.height10 * 15,
            height: Dimensions.height10 * 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height10 * 1.5),
                color: Colors.deepPurple),
            child: Center(
                child: Text(
              "Edit",
              style: TextStyle(
                  fontSize: Dimensions.height10 * 1.7,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
        )
      ]),
    );
  }
}
