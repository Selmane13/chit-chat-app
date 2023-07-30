import 'dart:convert';
import 'dart:io';

import 'package:chit_chat/api/notifications.dart';
import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/repos/user_repo.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  final UserRepo userRepo;
  UserModel? _userModel;
  List<dynamic> _searchedUsersList = [];
  File? _image;

  int _currSearchedUser = 0;
  int get currSearchedUser => _currSearchedUser;
  set setCurrSearchedUser(int index) {
    _currSearchedUser = index;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? get image => _image;

  List<dynamic> get searchedUsersList => _searchedUsersList;

  UserModel get userModel => _userModel!;
  set setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  UserController({required this.userRepo});

  Future<bool> signUp(String username, String password, String email) async {
    _isLoading = true;
    update();
    Map<String, String> body = {
      "username": username,
      "password": password,
      "email": email,
      "phone": "",
      "deviceToken": Get.find<NotificationManager>().deviceToken!
    };
    Response response = await userRepo.signUp(body);
    if (response.statusCode == 200) {
      print(response.body);
      _userModel = UserModel(
          user_id: response.body["insertId"].toString(),
          username: username,
          email: email,
          phone: "",
          img: "");
      _isLoading = false;
      update();
      return true;
    } else {
      print("response" + response.statusCode.toString());
      _isLoading = false;
      update();
      return false;
    }
  }

  Future<bool> signIn(
    String email,
    String password,
  ) async {
    _isLoading = true;
    update();
    Map<String, String> body = {
      "email": email,
      "password": password,
      "deviceToken": Get.find<NotificationManager>().deviceToken!
    };
    Response response = await userRepo.signIn(body);
    if (response.statusCode == 200) {
      _userModel = UserModel(
          user_id: response.body["user_id"].toString(),
          username: response.body["username"],
          email: email,
          phone: response.body["phone"],
          img: response.body["img"] ?? "",
          password: response.body["password"]);
      userRepo.apiClient.token = response.body["Authorization"];
      userRepo.apiClient.updateHeader(response.body["Authorization"]);
      await userRepo.saveUserInfo([
        _userModel!.user_id,
        _userModel!.username,
        _userModel!.email,
        _userModel!.phone!,
        _userModel!.img!,
        _userModel!.password!
      ]);
      _isLoading = false;
      update();
      return true;
    } else {
      print("response" + response.statusCode.toString());
      _isLoading = false;
      update();
      return false;
    }
  }

  Future<bool> editUsername(String username) async {
    Response response = await userRepo.editUsername(username);
    if (response.statusCode == 200) {
      userModel.username = username;
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editEmail(String email) async {
    Response response = await userRepo.editEmail(email);
    if (response.statusCode == 200) {
      userModel.email = email;
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPhone(String phone) async {
    Response response = await userRepo.editPhone(phone);
    if (response.statusCode == 200) {
      userModel.phone = phone;
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await clearDeviceToken();
    _userModel = null;
    await userRepo.clearStorage();
  }

  Future<void> searchUsers(String username) async {
    if (username.isEmpty) {
      _searchedUsersList = [];
      update();
    } else {
      Response response = await userRepo.searchUsers(username);
      if (response.statusCode == 200) {
        _searchedUsersList = response.body;
        var userToDelete;
        for (var user in _searchedUsersList) {
          if (user['user_id'].toString() == _userModel!.user_id) {
            userToDelete = user;
          }
        }
        _searchedUsersList.remove(userToDelete);
        update();
      } else {
        print("err in search Users: " + response.statusText.toString());
      }
    }
  }

  Future<void> pickImage() async {
    XFile? pickedFile;
    final picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      update();
      await updateImg();
      update();
    }
  }

  Future<void> updateImg() async {
    if (_image != null) {
      http.StreamedResponse response =
          await userRepo.updateImg(_image!, _userModel!.user_id);
      if (response.statusCode == 200) {
        Map map = jsonDecode(await response.stream.bytesToString());
        _userModel!.img = map['filePath'];
        print("image updated succefully " + _userModel!.img!);
        update();
      } else {
        print("err in updating image");
      }
    }
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    Response response = await userRepo.getUser(userId);
    if (response.statusCode == 200) {
      return response.body[0];
    } else {
      print("err in getUser");
      return null;
    }
  }

  Future<void> clearDeviceToken() async {
    Response response = await userRepo.clearDeviceToken(_userModel!.user_id);
    if (response.statusCode == 200) {
      print("deviceToken removed succefully");
    } else {
      print("err in clear Device token ${response.statusText}");
    }
  }
}
