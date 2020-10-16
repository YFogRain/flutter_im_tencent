import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/ui/main/HomeWidget.dart';
import 'package:tencent_im_example/ui/widget/LoadingDialog.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginWidget> {
  TextEditingController controller = TextEditingController();

  Widget _getWidget() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(),
                flex: 1,
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                cursorWidth: 1,
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 10),
                    fillColor: AppColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.lineColor, width: 1)),
                    hintText: "请输入用户id",
                    hintStyle:
                        TextStyle(color: AppColors.hintColor, fontSize: 13)),
                onChanged: (String value) {
                  print("value:$value}");
                },
              ),
              Container(
                height: 40,
              ),
              ButtonTheme(
                height: 45,
                child: RaisedButton(
                  color: AppColors.splashColor,
                  textColor: Colors.white,
                  child: Text("登录"),
                  onPressed: () {
                    _login();
                  },
                  elevation: 0,
                  disabledElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///登录
  void _login() async {
    var userId = controller.text;
    print("userId:$userId");
    if (userId == null || userId.isEmpty) return;
    showLoad();
    print("showLoad");
    var key = await IMManager().getTestSig(userId, 1400330071, "2d840c3a1997c8c93a70ff204a996fbc4d5c124dc8a20b61a026d310047a6da4");
    print("key:$key");
    var isLogin = await IMManager().loginIM(userId, key);
    print("isLogin:$isLogin");
    dismissDialog();
    if (!isLogin) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeWidget()));
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
}
