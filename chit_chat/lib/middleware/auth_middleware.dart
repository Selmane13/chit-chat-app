import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/routes/route_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/conversation_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    List<String>? userInfo =
        Get.find<SharedPreferences>().getStringList("userInfo");
    if (userInfo != null) {
      Get.find<UserController>().setUserModel = UserModel(
          user_id: userInfo[0],
          username: userInfo[1],
          email: userInfo[2],
          phone: userInfo[3],
          img: userInfo[4],
          password: userInfo[5]);
      //Get.put(ConversationController(conversationRepo: Get.find()));
      return RouteSettings(name: RouteHelper.getHomePage());
    }
  }
}
