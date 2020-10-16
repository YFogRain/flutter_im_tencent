import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im/im/model/MessageInfoModel.dart';
import 'package:tencent_im_example/ui/user/UserDetailWidget.dart';
import 'package:tencent_im_example/utils/AppColors.dart';
import 'package:tencent_im_example/utils/Utils.dart';

class ChatWidget extends StatefulWidget {
  final String imId;
  final bool isGroup;
  final String name;

  ChatWidget(this.imId, this.isGroup, this.name) : super();

  @override
  State<StatefulWidget> createState() => ChatState();
}

class ChatState extends State<ChatWidget> {
  var str = "";
  List<MessageInfoModel> _lists = [];
  TextEditingController controller = TextEditingController();

  var isShowMore = false;
  var isShowFace = false;
  var isShowAudio = false;
  var isShowSend = false;

  Widget _getWidget() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.navigationBarColor,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              height: 30,
            ),
            Container(
              color: Colors.white,
              height: 45,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Image.asset(
                          "images/arrow_left.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        widget.name == null ? "" : widget.name,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: 55,
                    child: Divider(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppColors.lineColor,
            ),
            Expanded(
              flex: 1,
              child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                  child: RefreshIndicator(
                    onRefresh: _pullToRefresh,
                    child: ListView.builder(
                      itemBuilder: _chatItemWidget,
                      itemCount: _lists.length,
                    ),
                    color: AppColors.splashColor,
                    backgroundColor: Colors.white,
                  )
                  ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      isShowAudio = !isShowAudio;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {});
                    },
                    child: Container(
                      child: Image.asset(
                        "images/ic_input_voice_normal.png",
                        height: 30,
                        width: 30,
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        isShowSend = value != null && value.isNotEmpty;
                        setState(() {});
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        fillColor: AppColors.navigationBarColor,
                        filled: true,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "",
                      ),
                    ),
                    flex: 1,
                  ),
                  InkWell(
                    onTap: () {
                      isShowFace = !isShowFace;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {});
                    },
                    child: Container(
                      child: Image.asset(
                        "images/ic_input_face_normal.png",
                        height: 30,
                        width: 30,
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: isShowSend
                        ? InkWell(
                            onTap: () {
                              _sendMessage();
                            },
                            child: Container(
                              width: 40,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: AppColors.sendBgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              alignment: Alignment.center,
                              child: Text(
                                "发送",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              isShowMore = !isShowMore;
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {});
                            },
                            child: Container(
                              child: Image.asset(
                                "images/ic_input_more_normal.png",
                                height: 30,
                                width: 30,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 释放
    controller.dispose();
    super.dispose();
  }

  ///发送文本消息
  void _sendMessage() async {
    var text = controller.text;
    var userModel = await IMManager().getLoginUser();

    MessageInfoModel model = MessageInfoModel();
    model.extra = text;
    model.msgType = MessageInfoModel.MSG_TYPE_TEXT;
    model.msgTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    model.fromUser = userModel.userID;
    model.showName = userModel.nickName;
    model.faceUrl = userModel.faceUrl;
    model.group = false;
    model.status = MessageInfoModel.MSG_STATUS_SENDING;
    model.self = true;

    _lists.add(model);
    controller.text = "";
    setState(() {});

    var isSend = await IMManager()
        .sendTextMessage(text, widget.imId, widget.isGroup, false);
    model.status = isSend
        ? MessageInfoModel.MSG_STATUS_SEND_SUCCESS
        : MessageInfoModel.MSG_STATUS_SEND_FAIL;
    setState(() {});
  }

  Future _pullToRefresh() async {
    return _loadHistory();
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Widget _chatItemWidget(BuildContext context, int index) {
    var data = _lists[index];
    return MessageItem(
      data: data,
      child: _getComponent(data),
    );
  }

  /// 获得组件
  Widget _getComponent(MessageInfoModel message) {
    if (message == null) return Text("");
    switch (message.msgType) {
      case MessageInfoModel.MSG_TYPE_TEXT:
        return MessageText(text: message.extra);
      case MessageInfoModel.MSG_TYPE_IMAGE:
        return MessageImage(
          path: message.snapshotPath,
          widthParam: message.width,
          heightParam: message.height,
        );
      case MessageInfoModel.MSG_TYPE_AUDIO:
        return MessageVoice(
          data: message,
        );
      case MessageInfoModel.MSG_TYPE_CUSTOM:
        return MessageText(text: "[自定义节点，未指定解析规则]");
        break;
      case MessageInfoModel.MSG_TYPE_VIDEO:
        return MessageVideo(
          data: message,
        );
      // case ChatModel.Location:
      //   LocationMessageNode value = node;
      //   return MessageLocation(
      //     desc: value.desc,
      //     latitude: value.latitude,
      //     longitude: value.longitude,
      //   );
      case MessageInfoModel.MSG_TYPE_TIPS:
        return MessageText(text: "[群提示节点，未指定解析规则]");
    }
    return MessageText(text: "[不支持的消息节点]");
  }

  var isFirst = true;
  void _loadHistory() async {
    print("imId:${widget.imId},isGroup:${widget.isGroup}");
    var loadChatHistory = await IMManager().loadChatHistory(widget.imId, 20, widget.isGroup,isFirst);
    print("loadChatHistory:$loadChatHistory");
    _loadSuccess(loadChatHistory);
    isFirst= false;
  }

  void _loadSuccess(List<MessageInfoModel> list) {
    print("list:$list");
    List<MessageInfoModel> dataList = [];

    if (list != null && list.length > 0) {
      dataList.addAll(list);
    }
    dataList.addAll(_lists);
    _lists = dataList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      //设置Android头部的导航栏透明
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark));
    }
    return _getWidget();
  }
}

/// 消息条目
class MessageItem extends StatelessWidget {
  /// 消息对象
  final MessageInfoModel data;

  /// 子组件
  final Widget child;

  const MessageItem({
    Key key,
    this.data,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isShowBg = _isShowBg();
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          !data.self
              ? Row(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UserDetailWidget(data.fromUser)));
                      },
                      child: CircleAvatar(
                        backgroundImage: data.faceUrl == null
                            ? null
                            : Image.network(
                          data.faceUrl,
                          fit: BoxFit.cover,
                        ).image,
                      ) ,
                    )
                   ,
                    Container(width: 5),
                  ],
                )
              : Container(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  data.self ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.showName ?? ""),
                Container(height: 5),
                isShowBg
                    ? Container(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 7,
                          right: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: data != null &&
                                data.status ==
                                    MessageInfoModel.MSG_STATUS_REVOKE
                            ? Text("[该消息已被撤回]")
                            : child,
                      )
                    : Container(child: child),
                Container(),
                data.status == MessageInfoModel.MSG_STATUS_SENDING
                    ? Text(
                        "发送中",
                        style: TextStyle(
                            fontSize: 9, color: AppColors.black33Color),
                      )
                    : data.status == MessageInfoModel.MSG_STATUS_SEND_FAIL
                        ? Text(
                            "发送失败",
                            style: TextStyle(
                                fontSize: 9, color: AppColors.black33Color),
                          )
                        : Container(),
              ],
            ),
          ),
          data.self
              ? Row(
                  children: <Widget>[
                    Container(width: 5),
                    CircleAvatar(
                      backgroundImage: data.faceUrl == null
                          ? null
                          : Image.network(
                              data.faceUrl,
                              fit: BoxFit.cover,
                            ).image,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  bool _isShowBg() {
    return data.msgType != MessageInfoModel.MSG_TYPE_FILE &&
        data.msgType != MessageInfoModel.MSG_TYPE_VIDEO &&
        data.msgType != MessageInfoModel.MSG_TYPE_IMAGE;
  }
}

/// 消息文本
class MessageText extends StatelessWidget {
  final String text;

  const MessageText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text == null ? "" : text);
  }
}

/// 消息图片
class MessageImage extends StatelessWidget {
  final String path;
  final int widthParam;
  final int heightParam;

  const MessageImage({Key key, this.path, this.widthParam, this.heightParam})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getImageParams = Utils.getImageParams(widthParam, heightParam);
    int width = getImageParams[0];
    int height = getImageParams[1];
    print("width:$width,height:$height");
    print("path:$path");
    return Container(
      height: height.toDouble(),
      width: width.toDouble(),
      child:
          path != null && path.isNotEmpty ? Image.network(path) : Container(),
    );
  }
}

/// 消息语音
class MessageVoice extends StatefulWidget {
  /// 消息实体
  final MessageInfoModel data;

  const MessageVoice({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageVoiceState();
}

class MessageVoiceState extends State<MessageVoice> {

  // 播放语音
  onPlayerOrStop() async {
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlayerOrStop,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.subject),
          Text("${widget.data == null ? "00:00" : widget.data.duration<10 ? "00:0"+widget.data.duration.toString():"00:" + widget.data.duration.toString()}″",style: TextStyle(fontSize: 9),),
        ],
      ),
    );
  }
}

/// 消息视频
class MessageVideo extends StatefulWidget {
  /// 消息实体
  final MessageInfoModel data;

  const MessageVideo({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageVideoState();
}

class MessageVideoState extends State<MessageVideo> {
  @override
  void initState() {
    super.initState();
    // });
  }

  /// 视频点击事件
  onVideoClick() async {}

  @override
  Widget build(BuildContext context) {
    var getImageParams =
        Utils.getImageParams(widget.data.width, widget.data.height);
    int width = getImageParams[0];
    int height = getImageParams[1];
    return InkWell(
      onTap: onVideoClick,
      child: Container(
        height: height.toDouble(),
        width: width.toDouble(),
        child: Stack(
          children: <Widget>[
            if (widget.data.snapshotPath != null &&
                widget.data.snapshotPath.isNotEmpty)
              Image.network(widget.data.snapshotPath),
            Align(
              alignment: new FractionalOffset(0.5, 0.5),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Text(
                "${widget.data == null ? "00:00" : widget.data.duration<10 ? "00:0"+widget.data.duration.toString():"00:" + widget.data.duration.toString()}″",
                style: TextStyle(fontSize:9,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// 消息位置
class MessageLocation extends StatelessWidget {
  /// 描述
  final String desc;

  /// 经度
  final double longitude;

  /// 纬度
  final double latitude;

  const MessageLocation({Key key, this.desc, this.longitude, this.latitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => 0,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child: Column(
          children: <Widget>[
            Text(desc),
            Text("经度:$longitude"),
            Text("纬度:$latitude"),
          ],
        ),
      ),
    );
  }
}
