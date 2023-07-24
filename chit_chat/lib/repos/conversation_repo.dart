import 'package:chit_chat/api/api_client.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';

class ConversationRepo extends GetxService {
  final ApiClient apiClient;

  ConversationRepo({required this.apiClient});

  Future<Response> getAllConversations(Map<String, String> body) async {
    return await apiClient
        .getData(AppConstants.GET_CONVERSATIONS + "/${body["user_id"]}");
  }

  Future<Response> getParticipantsOfConversation(String conversationId) async {
    return await apiClient
        .getData(AppConstants.GET_PARTICIPANTS + "/$conversationId");
  }

  Future<Response> getMssgsofConversation(
      String conversationId, String senderId) async {
    return await apiClient.getData(AppConstants.GET_MESSAGES_OF_CONVERSATION1 +
        "/$conversationId" +
        AppConstants.GET_MESSAGES_OF_CONVERSATION2 +
        "/$senderId");
  }

  Future<Response> sendMessage(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.SEND_MESSAGE_URI, body);
  }

  Future<Response> getMessage(String message_id) async {
    return await apiClient
        .getData(AppConstants.GET_MESSAGE_URI + "/$message_id");
  }

  Future<Response> newConversation(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.NEW_CONVERSATION, body);
  }
}
