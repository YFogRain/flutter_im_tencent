import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tencent_im/im/model/GroupMemberModel.dart';
import 'package:tencent_im/im/model/GroupMemberResultModel.dart';
import 'package:tencent_im/im/model/GroupModel.dart';
import 'package:tencent_im/im/model/UserModel.dart';

import 'enums/log_print_level.dart';
import 'model/ConsultModel.dart';
import 'model/MessageInfoModel.dart';

class IMManager {
  static IMManager _instance;

  final MethodChannel _imMethodChannel;
  final EventChannel _imEventChannel;

  factory IMManager() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('tencent_im/dim_method');
      final EventChannel eventChannel =
          const EventChannel('tencent_im/dim_event');
      _instance = new IMManager.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  IMManager.private(this._imMethodChannel, this._imEventChannel);

  Stream<dynamic> _listener;

  Stream<dynamic> get onMessage {
    if (_listener == null) {
      _listener = _imEventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => event);
    }
    return _listener;
  }

  ///im初始化
  Future<bool> init(int appId, LogPrintLevel level) async {
    var initBool =
        await _imMethodChannel.invokeMethod("initIM", <String, dynamic>{
      'app_id': appId,
      "level": LogPrintLevelTool.toInt(level),
    });
    return initBool != null && initBool;
  }

  ///是否登錄
  Future<bool> isLoginIM() async {
    var invokeMethod = await _imMethodChannel.invokeMethod("isLoginIM");
    return invokeMethod != null && invokeMethod;
  }

  ///登錄
  Future<bool> loginIM(String userId, String key) async {
    var loginResult = await _imMethodChannel.invokeMethod(
        "loginIM", <String, dynamic>{"user_id": userId, "user_key": key});
    return loginResult != null && loginResult;
  }

  ///退出登录
  Future<bool> loginOutIM() async {
    var loginOutResult = await _imMethodChannel.invokeMethod("loginOut");
    return loginOutResult != null && loginOutResult;
  }

  ///获取会话列表
  Future<List<ConsultModel>> getConversations(
      int startIndex, int endIndex) async {
    var conversationsStr = await _imMethodChannel.invokeMethod(
        "getConversations",
        <String, dynamic>{"startIndex": startIndex, "endIndex": endIndex});
    List<ConsultModel> consultModelList = [];
    if (conversationsStr != null) {
      var conversationsList = json.decode(conversationsStr);
      conversationsList.forEach((element) {
        var consultModel = ConsultModel.fromJson(Map.from(element));
        consultModelList.add(consultModel);
      });
    }
    return consultModelList;
  }

  ///删除会话
  Future<bool> deleteConversation(String conversationId) async {
    var isDelete = await _imMethodChannel.invokeMethod("deleteConversation",
        <String, dynamic>{"conversationId": conversationId});
    return isDelete != null && isDelete;
  }

  ///获取登录的用户名
  Future<String> getLoginUserStr() async {
    return await _imMethodChannel.invokeMethod("getLoginUserId");
  }

  ///获取登录的用户名
  Future<UserModel> getLoginUser() async {
    return await getOneUserDetail(await getLoginUserStr());
  }

  ///获取单个用户信息
  Future<UserModel> getOneUserDetail(String userId) async {
    if (userId == null || userId.isEmpty) {
      return null;
    }
    var list = await getUserData([userId]);
    if (list == null || list.isEmpty) {
      return null;
    }
    return list[0];
  }

  ///获取用户信息集合
  Future<List<UserModel>> getUserData(List<String> strList) async {
    var userStr = await _imMethodChannel
        .invokeMethod("getUserData", {"userList": strList});
    List<UserModel> userModelList = [];
    if (userStr != null) {
      var userLists = json.decode(userStr);
      userLists.forEach((element) {
        userModelList.add(UserModel.fromJson(Map.from(element)));
      });
    }
    return userModelList;
  }

  ///发送文本消息
  Future<bool> sendTextMessage(
      String content, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendTextMessage", <String, dynamic>{
      "content": content,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送图片消息
  Future<bool> sendImageMessage(
      String imagePath, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendImageMessage", <String, dynamic>{
      "imagePath": imagePath,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送语音消息
  Future<bool> sendSoundMessage(String audioPath, int duration, String imId,
      bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel
        .invokeMethod("sendSoundMessage", <String, dynamic>{
      "audioPath": audioPath,
      "duration": duration,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送視頻消息
  Future<bool> sendVideoMessage(
      String videoPath, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendVideoMessage", <String, dynamic>{
      "videoPath": videoPath,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送文件消息
  Future<bool> sendFileMessage(
      String filePath, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendFileMessage", <String, dynamic>{
      "filePath": filePath,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送自定义表情消息
  Future<bool> sendCustomFaceMessage(
      String faceName, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendCustomFaceMessage", <String, dynamic>{
      "faceName": faceName,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送自定义消息
  Future<bool> sendCustomMessage(
      String customStr, String imId, bool isGroup, bool retry) async {
    var isSend = await _imMethodChannel.invokeMethod(
        "sendCustomMessage", <String, dynamic>{
      "customStr": customStr,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///发送@消息
  Future<bool> sendAtMessage(List<String> atUserList, String message,
      String imId, bool isGroup, bool retry) async {
    var isSend =
        await _imMethodChannel.invokeMethod("sendAtMessage", <String, dynamic>{
      "atUserList": atUserList,
      "message": message,
      "isGroup": isGroup,
      "imId": imId,
      "retry": retry
    });
    return isSend != null && isSend;
  }

  ///获取聊天历史
  Future<List<MessageInfoModel>> loadChatHistory(
      String imId, int size, bool isGroup, bool isFirst) async {
    List<MessageInfoModel> messageList = [];
    var historyData = await _imMethodChannel
        .invokeMethod("loadChatHistory", <String, dynamic>{
      "imId": imId,
      "size": size,
      "isGroup": isGroup,
      "isFirst": isFirst,
    });
    if (historyData != null) {
      var historyList = json.decode(historyData);
      historyList.forEach((element) {
        messageList.add(MessageInfoModel.fromJson(Map.from(element)));
      });
    }
    print("historyData:$historyData");
    return messageList;
  }

  ///设置消息已读
  Future<bool> messageRead(String imId, bool isGroup) async {
    var isSetRead = await _imMethodChannel
        .invokeMethod("messageRead", {"imId": imId, "isGroup": isGroup});
    return isSetRead != null && isSetRead;
  }

  ///获取测试的签名
  Future<String> getTestSig(String userId, int appId, String secretKey) async {
    var key = await _imMethodChannel.invokeMethod("test_sig", <String, dynamic>{
      "userId": userId,
      "sdkAppId": appId,
      "secretKey": secretKey
    });
    return key == null ? "" : key;
  }

  ///获取好友列表
  Future<List<UserModel>> getFriendList() async {
    List<UserModel> userList = [];
    var friendMapStr = await _imMethodChannel.invokeMethod("getFriendList");
    if (friendMapStr != null) {
      var friendMapList = json.decode(friendMapStr);
      friendMapList.forEach((element) {
        userList.add(UserModel.fromJson(Map.from(element)));
      });
    }
    return userList;
  }

  ///检查好友关系
  Future<bool> checkFriend(String userId, {bool isSingleFriend = true}) async {
    var isFriend = await _imMethodChannel.invokeMethod(
        "checkFriend", {"userId": userId, "isSingleFriend": isSingleFriend});
    return isFriend != null && isFriend;
  }

  ///添加好友
  Future<bool> addFriend(String userId,
      {String source,
      String wording,
      String remark,
      bool isSingleFriend = false}) async {
    var isSendOk = await _imMethodChannel.invokeMethod("addFriend", {
      "userId": userId,
      "source": source,
      "wording": wording,
      "remark": remark,
      "isSingleFriend": isSingleFriend
    });
    return isSendOk != null && isSendOk;
  }

  ///删除好友
  Future<bool> deleteFriend(List<String> userIdList,
      {bool isDeleteSingle = true}) async {
    var isDeleteOk = await _imMethodChannel.invokeMethod("deleteFriend", {
      "userList": userIdList,
      "isDeleteSingle": isDeleteSingle,
    });
    return isDeleteOk != null && isDeleteOk;
  }

  ///获取好友列表
  Future<List<GroupModel>> getGroupList() async {
    List<GroupModel> userList = [];
    var friendMapStr = await _imMethodChannel.invokeMethod("getGroupList");
    if (friendMapStr != null) {
      var friendMapList = json.decode(friendMapStr);
      friendMapList.forEach((element) {
        userList.add(GroupModel.fromJson(Map.from(element)));
      });
    }
    return userList;
  }

  ///获取好友列表
  Future<GroupMemberResultModel> getGroupMemberList(String groupId,
      {int filter = 0, int nextSeq = 0}) async {
    var groupMemberStr =
        await _imMethodChannel.invokeMethod("getGroupMemberList", {
      "groupId": groupId,
      "filter": filter,
      "nextSeq": nextSeq,
    });
    if (groupMemberStr != null) {
      var encode = json.decode(groupMemberStr);
      var nextSeq = encode["nextSeq"];
      List<GroupMemberModel> memberInfoList = [];
      var memberInfoStr = encode["memberInfoList"];

      memberInfoStr.forEach((element) {
        memberInfoList.add(GroupMemberModel.fromJson(Map.from(element)));
      });
      return GroupMemberResultModel(
          nextSeq: nextSeq, memberInfoList: memberInfoList);
    }
    return null;
  }

  ///获取群资料-list
  ///groupIdList-获取的群id集合
  Future<List<GroupModel>> getGroupDetailList(List<String> groupIdList) async {
    var groupDetailListStr =
        await _imMethodChannel.invokeMethod("getGroupDetailList", {
      "groupIdList": groupIdList,
    });
    List<GroupModel> userList = [];
    if (groupDetailListStr != null) {
      var friendMapList = json.decode(groupDetailListStr);
      friendMapList.forEach((element) {
        userList.add(GroupModel.fromJson(Map.from(element)));
      });
    }
    return userList;
  }

  ///获取单个群资料
  Future<GroupModel> getGroupDetail(String groupId) async {
    var list = await getGroupDetailList([groupId]);
    return list == null || list.isEmpty ? null : list[0];
  }

  ///-----创建群组-----
  ///memberList-新建群时邀请的成员id列表
  ///groupName -群名称
  ///groupType -创建的群类型-取值范围GroupType类字段
  ///
  Future<bool> createGroup(
      List<String> memberList, String groupName, String groupType) async {
    var isCreate = await _imMethodChannel.invokeMethod("createGroup", {
      "memberList": memberList,
      "groupType": groupType,
      "groupName": groupName,
    });
    return isCreate != null && isCreate;
  }

  ///退出群组
  /// -1为成功，其他都为失败
  Future<int> quitGroup(String groupId) async {
    var isQuit =
        await _imMethodChannel.invokeMethod("quitGroup", {"groupId": groupId});
    return isQuit;
  }

  ///解散群组
  Future<bool> dismissGroup(String groupId) async {
    var isDismiss = await _imMethodChannel
        .invokeMethod("dismissGroup", {"groupId": groupId});
    return isDismiss != null && isDismiss;
  }


  ///----修改个人资料------
  ///selfSignature-签名
  /// nickName-昵称
  /// allowType -加群类型，取FriendAllowType内的值
  /// faceUrl-头像地址
  /// gender-性别，取GenderType内的值
  /// customInfo-设置自定义字段
  ///
  Future<bool> modifySelfInfo({String selfSignature, String nickName, int allowType, String faceUrl, int gender, String customInfo,}) async {
    var isModify = await _imMethodChannel.invokeMethod("modifySelfInfo", {
      "selfSignature": selfSignature,
      "nickName": nickName,
      "allowType": allowType,
      "faceUrl": faceUrl,
      "gender": gender,
      "customInfo": customInfo,
    });
    return isModify != null && isModify;
  }
}
