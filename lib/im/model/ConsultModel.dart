class ConsultModel {
  String showName;
  String faceUrl;
  int unreadCount = 0;
  bool isGroup = false;
  String imId;
  String conversationID;
  int contentAtType =0;//@类型
  String age ="";
  int gender = -1;
  ConversationModel lastMessage;

  ConsultModel.fromJson(Map<String, dynamic> json)
      : showName = json["showName"],
        faceUrl = json["faceUrl"],
        unreadCount = json["unreadCount"],
        isGroup = json["isGroup"],
        imId = json["imId"],
        conversationID = json["conversationID"],
        contentAtType = json["contentAtType"],
        lastMessage = ConversationModel.fromJson(Map.from(json["lastMessage"]));
}


class ConversationModel{
  int timestamp;
  String content;
  bool messageIsSelf;
  int messageType;


  @override
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'content': content,
    'messageIsSelf': messageIsSelf,
    'messageType': messageType,
  };

  ConversationModel.fromJson(Map<String, dynamic> json)
      : timestamp = json["timestamp"],
        content = json["content"],
        messageIsSelf = json["messageIsSelf"],
        messageType = json["messageType"];
}