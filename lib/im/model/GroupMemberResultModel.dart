import 'package:flutter/foundation.dart';

import 'GroupMemberModel.dart';

class GroupMemberResultModel {
  int nextSeq;
  List<GroupMemberModel> memberInfoList;

  GroupMemberResultModel({this.nextSeq, this.memberInfoList});
}
