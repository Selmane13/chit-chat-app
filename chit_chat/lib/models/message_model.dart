class MessageModel {
  String? messageId;
  String? conversationId;
  String? senderId;
  String? messageContent;
  String? timestamp;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.messageContent,
    required this.timestamp,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    messageId = json["message_id"].toString();
    conversationId = json["conversation_id"].toString();
    senderId = json["sender_id"].toString();
    messageContent = json["message_content"];
    timestamp = json["timestamp"].toString();
  }
}
