package com.example.tencent_im

import com.tencent.imsdk.v2.V2TIMMessage
import java.util.*

/**
 *  Create by rain
 *  Date: 2020/10/14
 */
class MessageInfoModel {
	companion object {
		const val MSG_TYPE_MIME = 0x1
		/**
		 * 文本类型消息
		 */
		const val MSG_TYPE_TEXT = 0x00
		/**
		 * 图片类型消息
		 */
		const val MSG_TYPE_IMAGE = 0x20
		/**
		 * 语音类型消息
		 */
		const val MSG_TYPE_AUDIO = 0x30
		/**
		 * 视频类型消息
		 */
		const val MSG_TYPE_VIDEO = 0x40
		/**
		 * 文件类型消息
		 */
		const val MSG_TYPE_FILE = 0x50
		/**
		 * 位置类型消息
		 */
		const val MSG_TYPE_LOCATION = 0x60
		/**
		 * 自定义图片类型消息
		 */
		const val MSG_TYPE_CUSTOM_FACE = 0x70
		/**
		 * 自定义消息
		 */
		const val MSG_TYPE_CUSTOM = 0x80
		/**
		 * 提示类信息
		 */
		const val MSG_TYPE_TIPS = 0x100
		/**
		 * 群创建提示消息
		 */
		const val MSG_TYPE_GROUP_CREATE = 0x101
		/**
		 * 群创建提示消息
		 */
		const val MSG_TYPE_GROUP_DELETE = 0x102
		/**
		 * 群成员加入提示消息
		 */
		const val MSG_TYPE_GROUP_JOIN = 0x103
		/**
		 * 群成员退群提示消息
		 */
		const val MSG_TYPE_GROUP_QUITE = 0x104
		/**
		 * 群成员被踢出群提示消息
		 */
		const val MSG_TYPE_GROUP_KICK = 0x105
		/**
		 * 群名称修改提示消息
		 */
		const val MSG_TYPE_GROUP_MODIFY_NAME = 0x106
		/**
		 * 群通知更新提示消息
		 */
		const val MSG_TYPE_GROUP_MODIFY_NOTICE = 0x107
		/**
		 * 消息未读状态
		 */
		const val MSG_STATUS_READ = 0x111
		/**
		 * 消息删除状态
		 */
		const val MSG_STATUS_DELETE = 0x112
		/**
		 * 消息撤回状态
		 */
		const val MSG_STATUS_REVOKE = 0x113
		/**
		 * 消息正常状态
		 */
		const val MSG_STATUS_NORMAL = 0
		/**
		 * 消息发送中状态
		 */
		const val MSG_STATUS_SENDING = 1
		/**
		 * 消息发送成功状态
		 */
		const val MSG_STATUS_SEND_SUCCESS = 2
		/**
		 * 消息发送失败状态
		 */
		const val MSG_STATUS_SEND_FAIL = 3
		/**
		 * 消息内容下载中状态
		 */
		const val MSG_STATUS_DOWNLOADING = 4
		/**
		 * 消息内容未下载状态
		 */
		const val MSG_STATUS_UN_DOWNLOAD = 5
		/**
		 * 消息内容已下载状态
		 */
		const val MSG_STATUS_DOWNLOADED = 6
		
	}
	var id = UUID.randomUUID().toString()
	var fromUser: String? = null
	var groupNameCard: String? = null
	var msgType = 0
	var status: Int = MSG_STATUS_NORMAL
	var self = false
	var group = false
	var dataPath: String? = null
	var dataUri:String? = null
	var extra: String? = null
	var msgTime: Long = 0
	var peerRead = false
	
	var tIMMessage: V2TIMMessage? = null
	var width: Int = 0
	var height: Int = 0
	
	fun getCustomInt(): Int {
		return if (tIMMessage == null) {
			0
		} else tIMMessage!!.localCustomInt
	}
	
	fun setCustomInt(value: Int) {
		if (tIMMessage == null) {
			return
		}
		tIMMessage?.localCustomInt = value
	}


}