import 'package:flutter/services.dart';
import 'package:tencent_im/im/model/UserModel.dart';

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
  Future<bool> init(int appId) async {
    var initBool =
    await _imMethodChannel.invokeMethod("initIM", <String, dynamic>{
      'app_id': appId,
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
  Future<List<ConsultModel>> getConversations(int startIndex,
      int endIndex) async {
    var conversationsList = await _imMethodChannel.invokeMethod(
        "getConversations",
        <String, dynamic>{"startIndex": startIndex, "endIndex": endIndex});
    List<ConsultModel> consultModelList = [];
    if (conversationsList != null) {
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
  Future<UserModel> getLoginUser() async {
    var loginUser = await _imMethodChannel.invokeMethod("loginUser");
    return loginUser == null ? null : UserModel.fromJson(Map.from(loginUser));
  }

  ///发送文本消息
  Future<bool> sendTextMessage(String content, String imId, bool isGroup,
      bool retry) async {
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
  Future<bool> sendImageMessage(String imagePath, String imId, bool isGroup,
      bool retry) async {
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
  Future<bool> sendVideoMessage(String videoPath, String imId, bool isGroup,
      bool retry) async {
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
  Future<bool> sendFileMessage(String filePath, String imId, bool isGroup,
      bool retry) async {
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
  Future<bool> sendCustomFaceMessage(String faceName, String imId, bool isGroup,
      bool retry) async {
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
  Future<bool> sendCustomMessage(String customStr, String imId, bool isGroup,
      bool retry) async {
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


  Future<List<MessageInfoModel>> loadChatHistory(String imId, int size, bool isGroup) async {
    List<MessageInfoModel> messageList = [];
    var historyData = await _imMethodChannel.invokeMethod(
        "loadChatHistory", <String, dynamic>{
      "imId": imId,
      "size": size,
      "isGroup": isGroup,
    });
    print("historyData:$historyData");
    return messageList;
  }


}
