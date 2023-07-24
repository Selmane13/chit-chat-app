import 'message_model.dart';

class ParticipantModel {
  String? participant_id;
  String? user_id;
  String? conversation_id;
  List<MessageModel> messages = [];

  ParticipantModel(
      {required this.conversation_id,
      required this.user_id,
      required this.participant_id});

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    participant_id = json["participant_id"].toString();
    user_id = json["user_id"].toString();
    conversation_id = json["conversation_id"].toString();
  }
}
