import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

import 'child/ConsultWidget.dart';
import 'child/MyWidget.dart';
import 'child/PatientWidget.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomeWidget> {
  List<Widget> list = [ConsultWidget(), PatientWidget(), MyWidget()];
  int _currentIndex = 0;

  Widget _getWidget() {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "images/consult_normal.png",
                width: 24,
                height: 24,
              ),
              activeIcon: Image.asset(
                "images/consult_select.png",
                width: 24,
                height: 24,
              ),
              title: Text(
                "聊天列表",
                style: TextStyle(fontSize: 14),
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "images/patient_normal.png",
                width: 24,
                height: 24,
              ),
              activeIcon: Image.asset(
                "images/patient_select.png",
                width: 24,
                height: 24,
              ),
              title: Text(
                "好友列表",
                style: TextStyle(fontSize: 14),
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "images/my_normal.png",
                width: 24,
                height: 24,
              ),
              activeIcon: Image.asset(
                "images/my_select.png",
                width: 24,
                height: 24,
              ),
              title: Text(
                "设置",
                style: TextStyle(fontSize: 14),
              )),
        ],
        type: BottomNavigationBarType.fixed,
        //默认选中首页
        selectedItemColor: AppColors.selectColor,
        unselectedItemColor: AppColors.unSelectColor,
        iconSize: 24.0,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initLogin();
  }

  void _initLogin() async {
    var isLogin = await IMManager().isLoginIM();
    print("isLogin:$isLogin");
    if (isLogin != null && isLogin) return;
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
