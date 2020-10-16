import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im/im/model/ConsultModel.dart';
import 'package:tencent_im_example/ui/chat/ChatWidget.dart';
import 'package:tencent_im_example/utils/AppColors.dart';
import 'package:tencent_im_example/utils/Constants.dart';

class ConsultWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConsultState();
}

class ConsultState extends State<ConsultWidget> {
  static const SHOW_EMPTY = 2;
  static const SHOW_LOAD = 0;
  static const SHOW_DATA = 1;
  List<ConsultModel> _lists = [];
  var showType = SHOW_LOAD;
  var isLoad = false;
  var unReadCount = 0;
  @override
  Widget build(BuildContext context) {
    return _getWidget();
  }

  Widget _getWidget() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Offstage(
                    offstage: showType != SHOW_DATA,
                    child: MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        removeTop: true,
                        removeLeft: true,
                        removeRight: true,
                        child: RefreshIndicator(
                          onRefresh: _pullToRefresh,
                          child: ListView.builder(
                            itemBuilder: noticeItemWidget,
                            itemCount: _lists.length,
                          ),
                          color: AppColors.splashColor,
                          backgroundColor: Colors.white,
                        )
                        ),
                  ),

                  Offstage(
                    offstage: showType != SHOW_LOAD,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: SpinKitFadingCircle(
                        color: AppColors.splashColor,
                      ),
                    ),
                  ),
                  //;loading
                  Offstage(
                      offstage: showType != SHOW_EMPTY,
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Divider(color: Colors.transparent),
                              ),
                              Image.asset(
                                "images/empty_icon.png",
                                height: 130,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 18),
                                child: Text(
                                  "暂无数据",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.normalColor),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Divider(color: Colors.transparent),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _loadData(true);
                        },
                      ))
                  //empty
                ],
              ),
            )
          ],
        ));
  }

  Widget noticeItemWidget(BuildContext context, int index) {
    ConsultModel model = this._lists[index];
    print("model:$model");
    return InkWell(
      onTap: () {
        _itemClick(model);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Container(
                    width: 56,
                    height: 52,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: model.faceUrl == null ||
                                        model.faceUrl.isEmpty
                                    ? AssetImage(model.isGroup
                                        ? "images/group_normal_icon.png"
                                        : "images/avatar_normal.png")
                                    : NetworkImage(model.faceUrl)),
                          ),
                        ),
                        Offstage(
                          offstage: model.unreadCount == null ||
                              model.unreadCount <= 0,
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 19,
                              alignment: Alignment.center,
                              height: 19,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.redTipsColor),
                              child: Text(
                                model.unreadCount.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 13, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Offstage(
                              offstage: model.showName == null ||
                                  model.showName.isEmpty,
                              child: Text(
                                model.showName == null ? "" : model.showName,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black33Color),
                              ),
                            ),
                            Offstage(
                              offstage:
                                  model.gender == null || model.gender <= 0,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  model.gender == 1
                                      ? "images/gendar_man.png"
                                      : "images/gendar_woman.png",
                                  width: 13,
                                  height: 13,
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: model.age == null || model.age.isEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(left: 9),
                                child: Text(
                                  model.age == null || model.age.isEmpty
                                      ? ""
                                      : model.age,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.normalColor),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Text(
                                  _timeToStr(model.lastMessage == null
                                      ? 0
                                      : model.lastMessage.timestamp),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.normalColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            model.lastMessage == null ||
                                    model.lastMessage.content == null ||
                                    model.lastMessage.content.isEmpty
                                ? "- -"
                                : model.lastMessage.content,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.normalColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.lineColor,
            height: 1,
          )
        ],
      ),
    );
  }

  String _timeToStr(int time) {
    return time == null || time == 0
        ? "- -"
        : formatDate(DateTime.fromMicrosecondsSinceEpoch(time * 1000 * 1000),
            [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
  }

  void _itemClick(ConsultModel model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatWidget(model.imId, model.isGroup,model.showName)));
  }

  StreamSubscription<dynamic> _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    IMManager().onMessage.listen((event) {
      if (event == null) return;
      List<ConsultModel> consultModelList = [];
      event.forEach((element) {
        var consultModel = ConsultModel.fromJson(Map.from(element));
        consultModelList.add(consultModel);
      });
      _updateConversation(consultModelList);
    });
    // _messageStreamSubscription =
    //     DIMManager().getDim().onMessage.listen((event) {
    //   print("我监听到数据了$event,需要在这里判断是你是消息列表还是需要刷新会话的请求。会话的请求是一个空的列表[],消息列表是有内容的");
    // });
    _loadData(true);
  }

  @override
  void dispose() {
    super.dispose();
    if (_messageStreamSubscription != null) _messageStreamSubscription.cancel();
  }

  Future _loadData(bool isShowLoad) async {
    if (isLoad) return;
    isLoad = true;
    if (isShowLoad) {
      showType = Constants.SHOW_LOAD;
      setState(() {});
    }
    var conversations = await IMManager().getConversations(0, 100);
    print("conversations:$conversations");
    _loadSuccess(conversations);
  }

  Future _pullToRefresh() async {
    return await _loadData(false);
  }

  void _loadSuccess(List<ConsultModel> list) {
    print("list:$list");
    _lists.clear();
    if (list != null && list.length > 0) {
      _lists.addAll(list);
    }
    isLoad = false;
    _showViewType();
  }

  void _updateConversation(List<ConsultModel> consultModelList) {
    if (isLoad) return;
    isLoad = true;
    unReadCount = 0;
    consultModelList.forEach((element) {
      var isHaveConsult = _isHaveConsult(element, _lists);
      if (isHaveConsult != null) {
        isHaveConsult.unreadCount = element.unreadCount;
        isHaveConsult.lastMessage = element.lastMessage;
        isHaveConsult.showName = element.showName;
        isHaveConsult.conversationID = element.conversationID;
        isHaveConsult.faceUrl = element.faceUrl;
        isHaveConsult.contentAtType = element.contentAtType;
        if (element.unreadCount > 0) {
          _lists.remove(isHaveConsult);
          _lists.insert(0, isHaveConsult);
        }
      } else {
        _lists.insert(0, element);
      }
      unReadCount += element.unreadCount;
    });
    isLoad = false;
    _showViewType();
  }

  ConsultModel _isHaveConsult(ConsultModel data, List<ConsultModel> lists) {
    lists.forEach((element) {
      if (element.imId != null &&
          element.imId.isNotEmpty &&
          data.imId != null &&
          data.imId.isNotEmpty &&
          data.imId == element.imId &&
          element.isGroup == data.isGroup) return element;
    });
    return null;
  }

  // void _loadFail() {
  //   isLoad = false;
  //   _showViewType();
  // }

  void _showViewType() {
    print("_lists:${_lists.length}");
    showType = _lists.length > 0 ? SHOW_DATA : SHOW_EMPTY;
    print("showType:$showType");
    setState(() {});
  }


}
