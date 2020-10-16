
class MessageInfoModel {
  MessageInfoModel();

  static const MSG_TYPE_MIME = 0x1;

  /// 文本类型消息
  static const MSG_TYPE_TEXT = 0x00;

  /// 图片类型消息
  static const MSG_TYPE_IMAGE = 0x20;

  /// 语音类型消息
  static const MSG_TYPE_AUDIO = 0x30;

  /// 视频类型消息
  static const MSG_TYPE_VIDEO = 0x40;

  /// 文件类型消息
  static const MSG_TYPE_FILE = 0x50;

  /// 位置类型消息
  static const MSG_TYPE_LOCATION = 0x60;

  /// 自定义图片类型消息
  static const MSG_TYPE_CUSTOM_FACE = 0x70;

  /// 自定义消息
  static const MSG_TYPE_CUSTOM = 0x80;

  /// 提示类信息
  static const MSG_TYPE_TIPS = 0x100;

  /// 群创建提示消息
  static const MSG_TYPE_GROUP_CREATE = 0x101;

  /// 群创建提示消息
  static const MSG_TYPE_GROUP_DELETE = 0x102;

  /// 群成员加入提示消息
  static const MSG_TYPE_GROUP_JOIN = 0x103;

  /// 群成员退群提示消息
  static const MSG_TYPE_GROUP_QUITE = 0x104;

  /// 群成员被踢出群提示消息
  static const MSG_TYPE_GROUP_KICK = 0x105;

  /// 群名称修改提示消息
  static const MSG_TYPE_GROUP_MODIFY_NAME = 0x106;

  /// 群通知更新提示消息
  static const MSG_TYPE_GROUP_MODIFY_NOTICE = 0x107;

  /// 消息未读状态
  static const MSG_STATUS_READ = 0x111;

  /// 消息删除状态
  static const MSG_STATUS_DELETE = 0x112;

  /// 消息撤回状态
  static const MSG_STATUS_REVOKE = 0x113;

  /// 消息正常状态
  static const MSG_STATUS_NORMAL = 0;

  /// 消息发送中状态
  static const MSG_STATUS_SENDING = 1;

  /// 消息发送成功状态
  static const MSG_STATUS_SEND_SUCCESS = 2;

  /// 消息发送失败状态
  static const MSG_STATUS_SEND_FAIL = 3;

  /// 消息内容下载中状态
  static const MSG_STATUS_DOWNLOADING = 4;

  /// 消息内容未下载状态
  static const MSG_STATUS_UN_DOWNLOAD = 5;

  /// 消息内容已下载状态
  static const MSG_STATUS_DOWNLOADED = 6;

  String showName;
  String faceUrl;
  String fromUser;
  int msgType = 0;
  int status =MSG_STATUS_NORMAL;
  bool self;// = false
  bool group;// = false
  String extra;//: String? = null
  int msgTime=0;//: Long = 0
  bool peerRead;// = false
  int width = 0;
  int height = 0;

  String snapshotPath = "";
  String dataPath = "";
  int duration =0; //时长


  Map<String, dynamic> toJson() => {
    'showName': showName,
    'faceUrl': faceUrl,
    'fromUser': fromUser,
    'msgType': msgType,
    'status': status,
    'self': self,
    'group': group,
    'extra': extra,
    'msgTime': msgTime,
    'peerRead': peerRead,
    'width': width,
    'height': height,
  };

  MessageInfoModel.fromJson(Map<String, dynamic> json)
      : faceUrl = json["faceUrl"],
        showName = json["showName"],
        fromUser = json["fromUser"],
        msgType = json["msgType"],
        status = json["status"],
        self = json["self"],
        group = json["group"],
        extra = json["extra"],
        msgTime = json["msgTime"],
        peerRead = json["peerRead"],
        snapshotPath = json["snapshotPath"],
        dataPath = json["dataPath"],
        duration = json["duration"],
        width = json["width"],
        height = json["height"];

}