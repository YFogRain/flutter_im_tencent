class GroupMemberModel {

  int role; //
  String userID; //   to it.userID,
  String faceUrl; //  to it.faceUrl,
  String nameCard; //       to it.nameCard,
  String nickName;
  String friendRemark; //        to it.friendRemark,
  int muteUntil; //     to it.muteUntil,
  int joinTime; //     to it.joinTime,
  Map<String,dynamic> customInfo; //     to it.customInfo,

  Map<String, dynamic> toJson() =>
      {
        "role": role,
        "userID": userID,
        "faceUrl": faceUrl,
        "nameCard": nameCard,
        "friendRemark": friendRemark,
        "muteUntil": muteUntil,
        "joinTime": joinTime,
        "customInfo": customInfo,
        "nickName": nickName,
      };

  GroupMemberModel.fromJson(Map<String, dynamic> json)
      : role = json["role"],
        userID = json["userID"],
        faceUrl = json["faceUrl"],
        nameCard = json["nameCard"],
        friendRemark = json["friendRemark"],
        muteUntil = json["muteUntil"],
        joinTime = json["joinTime"],
        nickName = json["nickName"],
        customInfo = json["customInfo"];

}