import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im/im/model/UserModel.dart';
import 'package:tencent_im_example/ui/chat/ChatWidget.dart';
import 'package:tencent_im_example/ui/widget/LoadingDialog.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

class UserDetailWidget extends StatefulWidget {
  final String userId;

  UserDetailWidget(this.userId);

  @override
  State<StatefulWidget> createState() => UserDetailState();
}

class UserDetailState extends State<UserDetailWidget> {
  UserModel model;
  bool isMeFriend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.lineColor,
          ),
          Container(
            height: 20,
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: model == null ||
                          model.faceUrl == null ||
                          model.faceUrl.isEmpty
                      ? AssetImage("images/avatar_normal.png")
                      : NetworkImage(model.faceUrl)),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            child: Text(
              "姓名:  " +
                  (model == null || model.nickName == null
                      ? ""
                      : model.nickName),
              style: TextStyle(fontSize: 15, color: AppColors.black33Color),
            ),
          ),
          Container(
            height: 5,
          ),
          Container(
            child: Text(
              "备注:  " +
                  (model == null || model.remark == null || model.remark.isEmpty
                      ? "- -"
                      : model.remark),
              style: TextStyle(fontSize: 15, color: AppColors.black33Color),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            child: Text(
              "性别:  " +
                  (model == null || model.gender == null || model.gender <= 0
                      ? "未知"
                      : model.gender == 1
                          ? "男"
                          : "女"),
              style: TextStyle(fontSize: 15, color: AppColors.black33Color),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            child: Text(
              "签名",
              style: TextStyle(fontSize: 15, color: AppColors.black33Color),
            ),
          ),
          Container(
            height: 5,
          ),
          Container(
            child: Text(
              model == null ||
                      model.selfSignature == null ||
                      model.selfSignature.isEmpty
                  ? "- -"
                  : model.selfSignature,
              style: TextStyle(fontSize: 15, color: AppColors.black33Color),
            ),
          ),
          Container(
            height: 30,
          ),
          ButtonTheme(
            padding: EdgeInsets.only(left: 60, right: 60),
            height: 40,
            child: RaisedButton(
              color: AppColors.splashColor,
              textColor: Colors.white,
              child: Text(isMeFriend ? "发送消息" : "添加好友"),
              onPressed: () {
                _sendMessage();
              },
              elevation: 0,
              disabledElevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          )
        ],
      ),
    );
  }

  _sendMessage() {
    if (isMeFriend) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatWidget(model.userID, false, model.nickName)));
      return;
    }
    addFriend();
  }

  void addFriend() async {
    showLoad();
    var addFriend =
        await IMManager().addFriend(model.userID, "flutter", "好友请求测试", null,false);
    dismissDialog();
    print("addFriend:$addFriend");
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void showLoad() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new LoadingDialog(
            outsideDismiss: false,
          );
        });
  }

  dismissDialog() {
    if (!ModalRoute.of(context).isCurrent) {
      Navigator.of(context).pop();
    }
  }

  void _loadUserData() async {
    model = await IMManager().getOneUserDetail(widget.userId);
    isMeFriend = await IMManager().checkFriend(widget.userId,true);
    setState(() {});
  }
}
