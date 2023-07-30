import 'dart:convert';

import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/models/message_model.dart';
import 'package:chit_chat/models/participant_model.dart';
import 'package:chit_chat/repos/conversation_repo.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../api/notifications.dart';
import '../models/conversation_model.dart';

class ConversationController extends GetxController {
  final ConversationRepo conversationRepo;
  late IO.Socket socket;
  final notificationManager = Get.find<NotificationManager>();

  ConversationController({required this.conversationRepo});

  List<ConversationModel> _conversations = [];
  int _currConversation = 0;
  List<Map<String, dynamic>?> _otherParticipants = [];
  List<Map<String, dynamic>?> get otherPartcipant => _otherParticipants;

  int get currConversation => _currConversation;
  set currConversation(int index) {
    _currConversation = index;
  }

  bool _loading = false;
  bool get loading => _loading;

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
  }

  void sendMessage(Map<String, dynamic> mssgBody) async {
    if (notificationManager.deviceToken == null) {
      notificationManager.getDeviceToken();
    }
    mssgBody.addAll(
        {"senderUsername": Get.find<UserController>().userModel.username});
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
    List<MessageModel> unsortedMessages = [];
    for (var i = 0; i < _conversations.length; i++) {
      for (var participant in _conversations[i].partcipants) {
        unsortedMessages.addAll(participant.messages);
      }
      unsortedMessages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
      _conversations[i].sortedMessages.clear();
      _conversations[i].sortedMessages.addAll(unsortedMessages);
      unsortedMessages = [];
    }

    _conversations.sort((a, b) {
      if (a.sortedMessages.isNotEmpty && b.sortedMessages.isNotEmpty) {
        final DateTime timestampA =
            DateTime.parse(a.sortedMessages.last.timestamp!);
        final DateTime timestampB =
            DateTime.parse(b.sortedMessages.last.timestamp!);
        return timestampB.compareTo(timestampA);
      } else {
        return 1;
      }
      // Sort in descending order
    });
  }

  void clearConversations() {
    _conversations = [];
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
    update();
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

  Future<void> deleteConversation(String conversationId, int index) async {
    print(conversationId);
    Response response =
        await conversationRepo.deleteConversation(conversationId);
    if (response.statusCode == 200) {
      _conversations.removeAt(index);
      _otherParticipants.removeAt(index);
      update();
      print("conversation deleted succefully");
    } else {
      update();
      print("err in deleteConversation ${response.statusText}");
    }
  }

  Future<void> deleteMessage(String messageId, int index) async {
    Response response = await conversationRepo.deleteMessage(messageId);
    if (response.statusCode == 200) {
      _conversations[_currConversation].sortedMessages.removeAt(index);
      for (var participant in _conversations[_currConversation].partcipants) {
        participant.messages
            .removeWhere((element) => element.messageId == messageId);
      }
      update();
      print("message deleted succefully");
    } else {
      update();
      print("err in deleteConversation ${response.statusText}");
    }
  }

  void clearOtherParticipants() {
    _otherParticipants = [];
  }

  @override
  void onInit() async {
    _loading = false;
    update();
    super.onInit();
    await getAllConversations();
    await getParticipantsOfAllConversation();
    await getMssgsOfParticipants();
    sortMessages();
    await getOtherParticipants();

    socket = IO.io(AppConstants.BASE_URL,
        OptionBuilder().setTransports(['websocket']).setTimeout(5000).build());
    socket.connect();
    socket.onConnectError((data) {
      print("error connecting to socekt.io  " + data);
    });
    socket.on("receive_message", (data) async {
      _conversations[_currConversation].sortedMessages.add(MessageModel(
          messageId: data["message_id"].toString(),
          conversationId: data["conversation_id"],
          senderId: data["sender_id"],
          messageContent: data["message_content"],
          timestamp: data["timestamp"]));
      update();
    });
    _loading = true;
    update();
  }

  @override
  void onClose() {
    clearConversations();
    super.onClose();
  }
}
