class UserModel {
  String nickName;
  String faceUrl;
  String selfSignature;
  int gender;
  String userID;
  String remark;
  int allowType = 0;

  Map<String, dynamic> toJson() => {
    'nickName': nickName,
    'faceUrl': faceUrl,
    'selfSignature': selfSignature,
    'gender': gender,
    'userID': userID,
    'remark': remark,
    'allowType': allowType,
  };

  UserModel.fromJson(Map<String, dynamic> json)
      : nickName = json["nickName"],
        faceUrl = json["faceUrl"],
        selfSignature = json["selfSignature"],
        gender = json["gender"],
        remark = json["remark"],
        allowType = json["allowType"],
        userID = json["userID"];
}
