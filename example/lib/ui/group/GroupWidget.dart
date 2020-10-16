import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/utils/AppColors.dart';
import 'package:tencent_im_example/utils/Constants.dart';
import 'package:tencent_im/im/model/GroupModel.dart';

class GroupWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GroupState();
}

class GroupState extends State<GroupWidget> {
  static const SHOW_EMPTY = 2;
  static const SHOW_LOAD = 0;
  static const SHOW_DATA = 1;
  List<GroupModel> _lists = [];
  var showType = SHOW_LOAD;
  var isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 30,
            ),
            Container(
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
                        "群组",
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
                  removeBottom: true,
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                  context: context,
                  child: ListView(
                    children: [
                      Offstage(
                        offstage: showType != Constants.SHOW_LOAD,
                        child: Container(
                          width: double.infinity,
                          height: 500,
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
                            _loadData();
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
                          itemBuilder: groupItemWidget,
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

  Widget groupItemWidget(BuildContext context, int index) {
    GroupModel model = this._lists[index];
    print("model:$model");
    return InkWell(
      onTap: () {
        // _itemClick(model);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                          model.faceUrl == null || model.faceUrl.isEmpty
                              ? AssetImage("images/group_normal_icon.png")
                              : NetworkImage(model.faceUrl)),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 15,right: 10),
                ),
                Text(

                  model.groupName == null ? "" : model.groupName,
                  style:
                  TextStyle(fontSize: 14, color: AppColors.black33Color),
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

  Future _loadData() async {
    if (isLoad) return;
    isLoad = true;
    showType = Constants.SHOW_LOAD;
    setState(() {});
    var lists = await IMManager().getGroupList();
    print("lists:$lists");
    _loadSuccess(lists);
  }

  void _loadSuccess(List<GroupModel> list) {
    print("list:$list");
    _lists.clear();
    if (list != null && list.length > 0) {
      _lists.addAll(list);
    }
    isLoad = false;
    _showViewType();
  }

  void _showViewType() {
    print("_lists:${_lists.length}");
    showType = _lists.length > 0 ? SHOW_DATA : SHOW_EMPTY;
    print("showType:$showType");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
}
