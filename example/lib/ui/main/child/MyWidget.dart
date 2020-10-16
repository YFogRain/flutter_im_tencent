import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyState();
}

class MyState extends State<MyWidget> {
  var name = "";
  var signature = "";
  var headImg = "";

  @override
  Widget getWidget() {
    print("getWidget:$name");
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 50,
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: headImg.isNotEmpty? NetworkImage(headImg): AssetImage("images/avatar_normal.png"))),
            ),
            Divider(
              height: 15,
              color: Colors.white,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Text(
                  name,
                  style:
                  TextStyle(fontSize: 20, color: AppColors.textColor),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            Divider(
              height: 15,
              color: Colors.white,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Text(
                  signature,
                  style: TextStyle(fontSize: 13, color: AppColors.sigColor),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Image.asset(
                    "images/content_icon.png",
                    width: 10,
                    height: 10,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            Divider(height: 47, color: Colors.white),
            Container(
              decoration: new BoxDecoration(
                color: AppColors.myBgColor,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Image.asset(
                              "images/settings_icon.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "设置",
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.black33Color),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Expanded(
                          flex: 1,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "images/arrow_right.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: new BoxDecoration(
                color: AppColors.myBgColor,
              )),
              flex: 1,
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _getName();
  }

  void _getName() async {
    print("_getName");
    var userModel = await IMManager().getLoginUser();
    if (userModel == null) return;
    name = userModel.nickName;
    signature = userModel.selfSignature == null ? "" : userModel.selfSignature;
    var img = userModel.faceUrl;
    headImg = img == null ? "" : img;
    setState(() {});
    print("name:$name");
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }
}
