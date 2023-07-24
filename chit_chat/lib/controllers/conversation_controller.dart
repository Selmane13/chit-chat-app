import 'dart:convert';

import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/models/message_model.dart';
import 'package:chit_chat/models/participant_model.dart';
import 'package:chit_chat/repos/conversation_repo.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../models/conversation_model.dart';

class ConversationController extends GetxController {
  final ConversationRepo conversationRepo;
  late IO.Socket socket;
  //final notificationManaging = Get.find<NotificationManaging();

  ConversationController({required this.conversationRepo});

  List<ConversationModel> _conversations = [];
  int _currConversation = 0;
  List<List<MessageModel>> _sortedMessages = [];
  List<Map<String, dynamic>?> _otherParticipants = [];
  List<Map<String, dynamic>?> get otherPartcipant => _otherParticipants;
  List<List<MessageModel>> get sortedMessages => _sortedMessages;

  int get currConversation => _currConversation;
  set currConversation(int index) {
    _currConversation = index;
  }

  List<ConversationModel> get conversations => _conversations;

  int? findConversation(String convId) {
    for (var i = 0; i < _conversations.length; i++) {
      if (convId == _conversations[i].conversation_id) {
        return i;
      }
    }
  }

  Future<bool> getAllConversations() async {
    Response response = await conversationRepo.getAllConversations(
        {"user_id": Get.find<UserController>().userModel.user_id});
    if (response.statusCode == 200) {
      _conversations = [];
      for (int i = 0; i < response.body.length; i++) {
        _conversations.add(ConversationModel.fromJson(response.body[i]));
      }
      update();
      return true;
    } else {
      print("err in getAllConversations : " + response.statusText.toString());
      return false;
    }
  }

  Future<void> getParticipantsOfConversation(
      String conversation_id, int index) async {
    Response response =
        await conversationRepo.getParticipantsOfConversation(conversation_id);

    if (response.statusCode == 200) {
      for (int i = 0; i < response.body.length; i++) {
        _conversations[index]
            .partcipants
            .add(ParticipantModel.fromJson(response.body[i]));
      }
    } else {
      print("err in getParticipants :" + response.statusText.toString());
    }
  }

  Future<void> getParticipantsOfAllConversation() async {
    if (_conversations.isNotEmpty) {
      for (int j = 0; j < _conversations.length; j++) {
        await getParticipantsOfConversation(
            _conversations[j].conversation_id!, j);
      }
    }
  }

  Future<void> getMessagesOfParticipant(String conversationId, String senderId,
      int convIndex, int partIndex) async {
    Response response =
        await conversationRepo.getMssgsofConversation(conversationId, senderId);
    if (response.statusCode == 200) {
      _conversations[convIndex].partcipants[partIndex].messages = [];
      for (int i = 0; i < response.body.length; i++) {
        _conversations[convIndex]
            .partcipants[partIndex]
            .messages
            .add(MessageModel.fromJson(response.body[i]));
      }
    } else {
      print("err in get mssg " + response.statusText.toString());
    }
  }

  Future<void> getMssgsOfParticipants() async {
    for (var i = 0; i < _conversations.length; i++) {
      for (var j = 0; j < _conversations[i].partcipants.length; j++) {
        await getMessagesOfParticipant(_conversations[i].conversation_id!,
            _conversations[i].partcipants[j].user_id!, i, j);
      }
    }
    sortMessages();
  }

  void sendMessage(Map<String, dynamic> mssgBody) async {
    /*if (notificationManaging.deviceToken == null) {
      notificationManaging.getDeviceToken();
    }
    mssgBody.addAll({"deviceToken": notificationManaging.deviceToken});*/
    socket.emit("send_message", mssgBody);
  }

  /*Response response = await conversationRepo.sendMessage(mssgBody);
    if (response.statusCode == 200) {
      MessageModel? message =
          await getMessage(response.body["insertId"].toString());
      if (message != null) {
        for (var participant in _conversations[_currConversation].partcipants) {
          if (participant.user_id ==
              Get.find<UserController>().userModel.user_id) {
            participant.messages.add(message);
            sortMessages();
            update();
          }
        }
      }

      return true;
    } else {
      print(response.statusText);

      return false;
    }*/

  Future<MessageModel?> getMessage(String message_id) async {
    Response response = await conversationRepo.getMessage(message_id);
    if (response.statusCode == 200) {
      return MessageModel.fromJson(response.body[0]);
    } else {
      print("err in getMessage : " + response.body);
    }
  }

  void sortMessages() {
    _sortedMessages = [];
    List<MessageModel> unsortedMessages = [];
    for (var conversation in _conversations) {
      for (var participant in conversation.partcipants) {
        unsortedMessages.addAll(participant.messages);
      }
      unsortedMessages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      _sortedMessages.add(unsortedMessages);
      unsortedMessages = [];
    }
  }

  void clearConversations() {
    _conversations = [];
    _sortedMessages = [];
  }

  Future<Map<String, dynamic>?> getOtherPartcipant(int index) async {
    var otherUser;
    for (var particpant in _conversations[index].partcipants) {
      if (particpant.user_id != Get.find<UserController>().userModel.user_id) {
        otherUser =
            await Get.find<UserController>().getUser(particpant.user_id!);
        return otherUser;
      }
    }
  }

  Future<void> getOtherParticipants() async {
    _otherParticipants = [];
    for (var i = 0; i < _conversations.length; i++) {
      _otherParticipants.add(await getOtherPartcipant(i));
    }
  }

  Future<String?> newConversation(
      String creatorId, String userId, String conversationName) async {
    Response response = await conversationRepo.newConversation({
      "conversation_name": conversationName,
      "participants": {"creator_user_id": creatorId, "second_user_id": userId}
    });
    if (response.statusCode == 200) {
      _conversations.add(ConversationModel(
          conversation_id: response.body["conversationId"].toString(),
          conversation_name: conversationName,
          creator_user_id: creatorId));
      _otherParticipants.add({"username": "jhon", "img": ""});
      print("new conversation created succefully");
      return response.body["conversationId"].toString();
    } else {
      print("err in new Conversation" + response.statusCode.toString());
    }
  }

  void clearOtherParticipants() {
    _otherParticipants = [];
  }

  @override
  void onInit() async {
    super.onInit();
    await getAllConversations();
    await getParticipantsOfAllConversation();
    await getMssgsOfParticipants();
    await getOtherParticipants();
    socket = IO.io(AppConstants.BASE_URL,
        OptionBuilder().setTransports(['websocket']).setTimeout(5000).build());
    socket.connect();
    socket.onConnectError((data) {
      print("error connecting to socekt.io  " + data);
    });
    socket.on("receive_message", (data) async {
      print("message received");
      await getMssgsOfParticipants();
      update();
    });
  }

  @override
  void onClose() {
    clearConversations();
    super.onClose();
  }
}
