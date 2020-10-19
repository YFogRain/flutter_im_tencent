class GroupRoleType {
  static final v2timGroupMemberUndefined = 0; //不知道
  static final v2timGroupMemberRoleMember = 200; //普通成员
  static final v2timGroupMemberRoleAdmin = 300; //群管理员
  static final v2timGroupMemberRoleOwner = 400; //群主
}

//创建群组的类型
class GroupType {
  static final work = "Work";
  static final meeting = "Meeting";
  static final private = "Private";
  static final chatRoom = "ChatRoom";
  static final public = "Public";
  static final aVChatRoom = "AVChatRoom";
}

class FriendAllowType{
  static final v2timFriendAllAny = 0;
  static final v2timFriendNeedConfirm = 1;
  static final v2timFriendDenyAny = 2;
}

class GenderType{
  static final v2timGenderUnknown = 0;
  static final v2timGenderMale = 1;
  static final v2timGenderFemale = 2;
}
