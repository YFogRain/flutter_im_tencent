import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im/im/model/UserModel.dart';
import 'package:tencent_im_example/ui/user/UserDetailWidget.dart';
import 'package:tencent_im_example/utils/AppColors.dart';
import 'package:tencent_im_example/utils/Constants.dart';

class PatientWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PatientState();
}

class PatientState extends State<PatientWidget> {
  var tipSize = 0;

  List<UserModel> _lists = [];

  var showType = Constants.SHOW_LOAD;
  var isLoad = false;

  Widget _getWidget() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: MediaQuery.removePadding(
                  removeBottom: true,
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                  context: context,
                  child: ListView(
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    "images/label_icon.png",
                                    width: 31,
                                    height: 31,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "新增好友",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          print("新增好友");
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 68),
                        child: Divider(
                          height: 1,
                          color: AppColors.labelLineColor,
                        ),
                      ),
                      InkWell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    "images/home_friend_add.png",
                                    width: 31,
                                    height: 31,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "好友申请",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Offstage(
                                offstage: tipSize == 0,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.redTipsColor,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 6, right: 6, top: 1, bottom: 1),
                                      child: Text(
                                        tipSize.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print("好友申请");
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 68),
                        child: Divider(
                          height: 1,
                          color: AppColors.labelLineColor,
                        ),
                      ),
                      InkWell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    "images/home_group_icon.png",
                                    width: 31,
                                    height: 31,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "群聊",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          print("群聊");
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 68),
                        child: Divider(
                          height: 1,
                          color: AppColors.labelLineColor,
                        ),
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(color: AppColors.myBgColor),
                      ),
                      Offstage(
                        offstage: showType != Constants.SHOW_LOAD,
                        child: Container(
                          width: double.infinity,
                          height: 350,
                          alignment: Alignment.center,
                          child: SpinKitFadingCircle(
                            color: AppColors.splashColor,
                          ),
                        ),
                      ),
                      //;loading
                      Offstage(
                        offstage: showType != Constants.SHOW_EMPTY,
                        child: GestureDetector(
                          onTap: () {
                            _loadData(true, true);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 350,
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
                        ),
                      ),
                      Offstage(
                        offstage: showType != Constants.SHOW_DATA,
                        child: ListView.builder(
                          itemBuilder: patientItemWidget,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _lists.length,
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  Widget patientItemWidget(BuildContext context, int index) {
    UserModel model = this._lists[index];
    //
    var name = model.remark != null && model.remark.isNotEmpty
        ? model.remark
        : model.nickName;

    return InkWell(
      onTap: () {
        _itemClick(model);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        child: Container(
                          width: 49,
                          height: 49,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: model.faceUrl == null ||
                                        model.faceUrl.isEmpty
                                    ? AssetImage("images/avatar_normal.png")
                                    : NetworkImage(model.faceUrl)),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Offstage(
                                  offstage: name == null || name.isEmpty,
                                  child: Text(
                                    name == null ? "" : name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                if (model.gender > 0)
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Image.asset(
                                      model.gender == 1
                                          ? "images/gendar_man.png"
                                          : "images/gendar_woman.png",
                                      width: 13,
                                      height: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _itemClick(UserModel model) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => UserDetailWidget(model.userID)));
  }

  @override
  void initState() {
    super.initState();
    _loadData(true, true);
  }

  void _loadData(bool isRefresh, bool isShowLoad) async {
    if (isLoad) return;
    isLoad = true;
    if (isRefresh) {
      if (isShowLoad) {
        showType = Constants.SHOW_LOAD;
        setState(() {});
      }
    }
    var list = await IMManager().getFriendList();
    if (list != null) {
      _loadSuccess(list);
      return;
    }
    _loadFail();
  }

  void _loadSuccess(List<UserModel> list) {
    print("list:$list");
    _lists.clear();
    _lists.addAll(list);
    print("list:${_lists.length}");
    isLoad = false;
    _showViewType();
  }

  void _loadFail() {
    isLoad = false;
    _showViewType();
  }

  void _showViewType() {
    showType = _lists.length > 0 ? Constants.SHOW_DATA : Constants.SHOW_EMPTY;
    print("showType:$showType");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _getWidget();
  }
}
