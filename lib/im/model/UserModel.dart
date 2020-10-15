class UserModel {
  String nickName;
  String faceUrl;
  String selfSignature;
  int gender;
  String userID;

  @override
  Map<String, dynamic> toJson() => {
    'nickName': nickName,
    'faceUrl': faceUrl,
    'selfSignature': selfSignature,
    'gender': gender,
    'userID': userID,
  };

  UserModel.fromJson(Map<String, dynamic> json)
      : nickName = json["nickName"],
        faceUrl = json["faceUrl"],
        selfSignature = json["selfSignature"],
        gender = json["gender"],
        userID = json["userID"];
}
