import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  //late String token;
  final appBaseUrl;
  late SharedPreferences sharedPreferences;
  late String token;
  //late final sharedPreferences;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF=8',
      'Authorization': token
    };
  }

  Future<Response> postData(String uri, Map<String, dynamic> body) async {
    try {
      Response response = await post(uri, body);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusText: e.toString());
    }
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(uri);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      Response response = await put(uri, body);
      print(response.statusText);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusText: e.toString());
    }
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF=8',
      'Authorization': token
    };
  }
}
