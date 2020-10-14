import 'package:flutter/services.dart';

import 'model/ConsultModel.dart';

class IMManager {
  static IMManager _instance;

  final MethodChannel _imMethodChannel;
  final EventChannel _imEventChannel;

  factory IMManager() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('tencent_im/dim_method');
      final EventChannel eventChannel = const EventChannel('tencent_im/dim_event');
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
    var initBool = await _imMethodChannel.invokeMethod("initIM", <String, dynamic>{
      'app_id': appId,
    });
    return initBool!=null && initBool;
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
  Future<List<ConsultModel>> getConversations(int startIndex, int endIndex) async {
    var conversationsList = await _imMethodChannel.invokeMethod("getConversations",<String,dynamic>{"startIndex":startIndex, "endIndex":endIndex});
    List<ConsultModel> consultModelList = [];
    if (conversationsList != null) {
      conversationsList.forEach((element) {
        var consultModel = ConsultModel.fromJson(Map.from(element));
        consultModelList.add(consultModel);
      });
    }
    return consultModelList;
  }
}
