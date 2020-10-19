import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im/im/model/GroupMemberModel.dart';
import 'package:tencent_im/im/model/GroupModel.dart';
import 'package:tencent_im/im/enums/GroupRoleType.dart';
import 'package:tencent_im_example/ui/user/UserDetailWidget.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

class GroupDetailWidget extends StatefulWidget {
  final String groupId;

  GroupDetailWidget(this.groupId);

  @override
  State<StatefulWidget> createState() => GroupDetailState();
}

class GroupDetailState extends State<GroupDetailWidget> {
  List<GroupMemberModel> _lists = [];

  GroupModel groupModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myBgColor,
      body: Column(
        children: [
          Container(
            height: 30,
            color: AppColors.white,
          ),
          Container(
            height: 45,
            color: AppColors.white,
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
                      groupModel==null||groupModel.groupName==null?"":groupModel.groupName,
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
          Container(
            height: 10,
            color: AppColors.white,
          ),
          Expanded(
            child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeLeft: true,
                removeTop: true,
                removeRight: true,
                child: ListView(
                  children: [
                    Container(
                      color: AppColors.white,
                      child: MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          removeLeft: true,
                          removeTop: true,
                          removeRight: true,
                          child: GridView.builder(
                            itemBuilder: groupItemWidget,
                            itemCount: _lists.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5, childAspectRatio: 6 / 6
                                    //子组件宽高长度比例
                                    ),
                          )),
                    ),
                    Container(
                      height: 10,
                      color: AppColors.myBgColor,
                    ),
                    Offstage(
                      offstage: groupModel==null|| groupModel.role!=null ||(groupModel.role != GroupRoleType.v2timGroupMemberRoleAdmin ||groupModel.role != GroupRoleType.v2timGroupMemberRoleOwner),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                        },
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "管理群成员",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
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
                      ) ,
                    )
                   ,
                    Offstage(
                      offstage: groupModel==null|| groupModel.role!=null ||(groupModel.role != GroupRoleType.v2timGroupMemberRoleAdmin ||groupModel.role != GroupRoleType.v2timGroupMemberRoleOwner),
                      child:Divider(
                        height: 1,
                        color: AppColors.lineColor,
                      ),
                    ),
                    Offstage(
                      offstage: groupModel==null|| groupModel.role!=null ||(groupModel.role != GroupRoleType.v2timGroupMemberRoleAdmin ||groupModel.role != GroupRoleType.v2timGroupMemberRoleOwner),
                      child:InkWell(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                        },
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "群名称",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black33Color),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
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
                    Offstage(
                      offstage: groupModel==null|| groupModel.role!=null ||(groupModel.role != GroupRoleType.v2timGroupMemberRoleAdmin ||groupModel.role != GroupRoleType.v2timGroupMemberRoleOwner),
                      child:Divider(
                        height: 1,
                        color: AppColors.lineColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                      },
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  "我的群昵称",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black33Color),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
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
                    Container(
                      height: 10,
                      color: AppColors.myBgColor,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                      },
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  "查找聊天内容",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black33Color),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
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
                    Container(
                      height: 10,
                      color: AppColors.myBgColor,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => SettingsWidget()));
                      },
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "删除并退出群聊",
                          style: TextStyle(
                              fontSize: 16, color: AppColors.redTipsColor),
                        ),
                      ),
                    ),
                  ],
                )),
            flex: 1,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMemberList();
    _loadGroupDetail();
  }

  void _loadGroupDetail() async {
    var groupModel = await IMManager().getGroupDetail(widget.groupId);
    this.groupModel = groupModel;
    print("groupModel.role:${groupModel.role}");
    setState(() {});
  }

  void _loadMemberList() async {
    var groupMemberResultModel =
        await IMManager().getGroupMemberList(widget.groupId);
    var memberInfoList = groupMemberResultModel.memberInfoList;
    _loadSuccess(memberInfoList);
  }

  void _loadSuccess(List<GroupMemberModel> list) {
    print("list:$list");
    _lists.clear();
    if (list != null && list.isNotEmpty) {
      _lists.addAll(list);
    }
    setState(() {});
  }

  Widget groupItemWidget(BuildContext context, int index) {
    var model = this._lists[index];
    print("model:$model");
    String memberName = model.nameCard == null || model.nameCard.isEmpty
        ? model.nickName == null || model.nickName.isEmpty
            ? model.userID
            : model.nickName
        : model.nameCard;
    return InkWell(
      onTap: () {
        _itemClick(model);
      },
      child: Column(
        children: [
          Padding(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: model.faceUrl == null || model.faceUrl.isEmpty
                        ? AssetImage("images/avatar_normal.png")
                        : NetworkImage(model.faceUrl)),
              ),
            ),
            padding: EdgeInsets.only(bottom: 5),
          ),
          Text(
            memberName == null ? "" : memberName,
            maxLines: 1,
            style: TextStyle(fontSize: 13, color: AppColors.black33Color),
          ),
        ],
      ),
    );
  }

  void _itemClick(GroupMemberModel model) async{
    var userModel = await IMManager().getLoginUser();
    if(userModel !=null && userModel.userID!=null&&userModel.userID.isNotEmpty){
      if(userModel.userID == model.userID) return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                UserDetailWidget(model.userID)));
  }
}
