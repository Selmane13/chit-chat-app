import 'package:chit_chat/models/message_model.dart';
import 'package:chit_chat/models/participant_model.dart';

class ConversationModel {
  String? conversation_id;
  String? conversation_name;
  String? creation_date;
  String? creator_user_id;
  List<ParticipantModel> partcipants = [];
  List<MessageModel> sortedMessages = [];

  ConversationModel({
    required this.conversation_id,
    required this.conversation_name,
    this.creation_date,
    required this.creator_user_id,
  });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    conversation_id = json["conversation_id"].toString();
    conversation_name = json["conversation_name"];
    creation_date = json["creation_date"].toString();
    creator_user_id = json["creator_user_id"].toString();
  }
}
