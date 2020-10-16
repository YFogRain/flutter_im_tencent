import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/ui/login/LoginWidget.dart';
import 'package:tencent_im_example/ui/main/HomeWidget.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

class SplashWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashWidget> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      //设置Android头部的导航栏透明
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: AppColors.splashColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light));
    }
    return _getWidget();
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 5), () {
      print("startNavigator");
      startData();
    });
  }

  void startData() async {
    var isLogin = await IMManager().isLoginIM();
    if(isLogin){
      startMain();
      return;
    }
    _login();
    // startLogin();
  }

  void startLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginWidget()));
  }
  ///登录
  void _login() async {
    print("showLoad");
    var key = await IMManager().getTestSig("test_doc_24", 1400330071, "2d840c3a1997c8c93a70ff204a996fbc4d5c124dc8a20b61a026d310047a6da4");
    print("key:$key");
    var isLogin = await IMManager().loginIM("test_doc_24", key);
    print("isLogin:$isLogin");
    if (!isLogin) {
      startLogin();
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeWidget()));
  }
  void startMain() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeWidget()));
  }

  Widget _getWidget() {
    return Scaffold(
        backgroundColor: AppColors.splashColor,
        body: Container(
          child: Align(
            child: Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: Text("腾讯IM-Flutter",style: TextStyle(fontSize: 20,color: Colors.white),)),
            alignment: Alignment.topCenter,
          ),
        ));
  }
}
