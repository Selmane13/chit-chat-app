import 'package:chit_chat/api/api_client.dart';
import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/repos/conversation_repo.dart';
import 'package:chit_chat/repos/user_repo.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  Get.lazyPut(
      () => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ConversationRepo(apiClient: Get.find()));

  Get.lazyPut(() => UserController(userRepo: Get.find()));
  //Get.lazyPut(() => ConversationController(conversationRepo: Get.find()));
}
