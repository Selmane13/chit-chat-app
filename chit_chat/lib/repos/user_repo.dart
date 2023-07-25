import 'dart:io';

import 'package:chit_chat/api/api_client.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  UserRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> signUp(Map<String, String> body) async {
    return await apiClient.postData(AppConstants.REGISTER_URI, body);
  }

  Future<Response> signIn(Map<String, String> body) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, body);
  }

  Future<Response> getUser(String userId) async {
    return await apiClient.getData(AppConstants.GET_USER + "/$userId");
  }

  Future<Response> editUsername(String username) async {
    return await apiClient.putData(AppConstants.EDIT_USERNAME, {
      "user_id": Get.find<UserController>().userModel.user_id,
      "username": username
    });
  }

  Future<Response> editPhone(String phone) async {
    return await apiClient.putData(AppConstants.EDIT_PHONE, {
      "user_id": Get.find<UserController>().userModel.user_id,
      "phone": phone
    });
  }

  Future<Response> editEmail(String email) async {
    return await apiClient.putData(AppConstants.EDIT_EMAIL, {
      "user_id": Get.find<UserController>().userModel.user_id,
      "email": email
    });
  }

  Future<Response> searchUsers(String username) async {
    return await apiClient.getData(AppConstants.SEARCH_USERS + "/$username");
  }

  Future<http.StreamedResponse> updateImg(File image, String userId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(AppConstants.BASE_URL + AppConstants.UPDATE_PROFILE));
    request.fields['user_id'] = userId;
    request.files.add(http.MultipartFile(
        'img', image.readAsBytes().asStream(), image.lengthSync(),
        filename: image.path.split('/').last));

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<void> saveUserInfo(List<String> info) async {
    await sharedPreferences.setStringList("userInfo", info);
  }

  Future<void> clearStorage() async {
    await sharedPreferences.clear();
  }
}
