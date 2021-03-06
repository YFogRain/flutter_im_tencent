package com.example.tencent_im

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.util.Log
import com.tencent.imsdk.TIMImageType
import com.tencent.imsdk.v2.*
import java.io.File


/**
 *  Create by rain
 *  Date: 2020/10/14
 */
object MessageInfoUtil {
	private const val GROUP_CREATE = "group_create"
	private const val GROUP_DELETE = "group_delete"
	
	
	/**
	 * 将会话列表状态转换为map
	 */
	fun conversationToMap(conversationData: V2TIMConversation): Map<String, Any?> {
		val conMap: MutableMap<String, Any?> = mutableMapOf()
		Log.d("imUserTag", "showName:${conversationData.showName}")
		Log.d("imUserTag", "faceUrl:${conversationData.faceUrl}")
		Log.d("imUserTag", "unreadCount:${conversationData.unreadCount}")
		Log.d("imUserTag", "type:${conversationData.type}")
		Log.d("imUserTag", "faceUrl:${conversationData.faceUrl}")
		Log.d("imUserTag", "conversationID:${conversationData.conversationID}")
		Log.d("imUserTag", "faceUrl:${conversationData.faceUrl}")
		
		
		conMap["showName"] = conversationData.showName
		conMap["faceUrl"] = conversationData.faceUrl
		conMap["unreadCount"] = conversationData.unreadCount
		conMap["isGroup"] = if (conversationData.type == V2TIMConversation.V2TIM_GROUP) {
			conMap["imId"] = conversationData.groupID
			true
		} else {
			conMap["imId"] = conversationData.userID
			false
		}
		conMap["conversationID"] = conversationData.conversationID
		conMap["contentAtType"] = getAtType(conversationData)
		
		val lastMessage = conversationData.lastMessage
		if (lastMessage != null) {
			conMap["lastMessage"] = mapOf<String, Any?>(
					"timestamp" to lastMessage.timestamp,
					"content" to lastMessage.textElem?.text,
					"messageIsSelf" to lastMessage.isSelf,
					"messageType" to lastMessage.elemType)
		}
		return conMap.toMap()
	}
	
	/**
	 * 获取会话列表@内容
	 */
	private fun getAtType(data: V2TIMConversation): Int {
		var atMe = false
		var atAll = false
		val groupAtInfoList = data.groupAtInfoList
		if (groupAtInfoList.isNullOrEmpty()) return V2TIMGroupAtInfo.TIM_AT_UNKNOWN
		groupAtInfoList.forEach {
			if (it.atType == V2TIMGroupAtInfo.TIM_AT_ME) {
				atMe = true
				return@forEach
			}
			if (it.atType == V2TIMGroupAtInfo.TIM_AT_ALL) {
				atAll = true
				return@forEach
			}
		}
		return if (atAll && atMe) V2TIMGroupAtInfo.TIM_AT_ALL_AT_ME
		else if (atAll) V2TIMGroupAtInfo.TIM_AT_ALL
		else if (atMe) V2TIMGroupAtInfo.TIM_AT_ME
		else V2TIMGroupAtInfo.TIM_AT_UNKNOWN
	}
	
	/**
	 * 创建@消息
	 */
	fun buildTextAtMessage(atUserList: MutableList<String>?, message: String?): V2TIMMessage? {
		if (atUserList.isNullOrEmpty() || message.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createTextAtMessage(message, atUserList)
	}
	
	/**
	 * 创建普通文本消息
	 */
	fun buildTextMessage(message: String?): V2TIMMessage? {
		if (message.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createTextMessage(message)
	}
	
	/**
	 * 创建图片消息
	 */
	fun buildImageMessage(path: String?): V2TIMMessage? {
		if (path.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createImageMessage(path)
	}
	
	
	/**
	 * 创建视频消息
	 */
	fun buildVideoMessage(context: Context, videoPath: String?): V2TIMMessage? {
		if (videoPath.isNullOrEmpty()) return null
		val retriever = MediaMetadataRetriever()
		var mimeType: String? = null
		var bitmap: Bitmap? = null
		var duration = ""
		try {
			retriever.setDataSource(videoPath)
			duration = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: ""
			mimeType = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE)
			bitmap = retriever.frameAtTime
		} catch (e: Exception) {
			e.printStackTrace()
		} finally {
			retriever.release()
			
		}
		val imagePath = if (bitmap != null) ImageUtils.saveBitmap(context, bitmap) else null
		
		return V2TIMManager.getMessageManager().createVideoMessage(videoPath, mimeType, (duration.toLong() / 1000).toInt(), imagePath)
	}
	
	/**
	 * 创建一条音频消息
	 */
	fun buildAudioMessage(recordPath: String?, duration: Int): V2TIMMessage? {
		if (recordPath.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createSoundMessage(recordPath, duration / 1000)
	}
	
	/**
	 * 创建文件消息
	 */
	fun buildFileMessage(path: String?): V2TIMMessage? {
		if (path.isNullOrEmpty()) return null
		val file = File(path)
		return V2TIMManager.getMessageManager().createFileMessage(path, file.name)
	}
	
	/**
	 * 创建一条自定义表情的消息
	 */
	fun buildCustomFaceMessage(faceName: String?): V2TIMMessage? {
		if (faceName.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createFaceMessage(-1, faceName.toByteArray())
	}
	
	/**
	 * 创建一条自定义消息
	 */
	fun buildCustomMessage(customStr: String?): V2TIMMessage? {
		if (customStr.isNullOrEmpty()) return null
		return V2TIMManager.getMessageManager().createCustomMessage(customStr.toByteArray())
	}
	
	
	/**
	 * 历史消息转换成list所需对象
	 */
	
	fun historyMessageListToMap(context: Context, messageList: MutableList<V2TIMMessage>?, isGroup: Boolean):MutableList<MessageInfoModel> ?{
		if (messageList.isNullOrEmpty()) return null
		val list: MutableList<MessageInfoModel> = mutableListOf()
		messageList.forEach {
			val ele2MessageInfo = ele2MessageInfo(context, it, isGroup)
			if (ele2MessageInfo != null) list.add(ele2MessageInfo)
		}
		list.sort()
		return list
	}
	
	private fun ele2MessageInfo(context: Context, timMessage: V2TIMMessage, isGroup: Boolean): MessageInfoModel? {
		Log.d("chatTag", "elemType:${timMessage.elemType}")
		with(MessageInfoModel(), {
			self = timMessage.isSelf
			msgTime = timMessage.timestamp
			fromUser = timMessage.sender
			peerRead = timMessage.isPeerRead
			faceUrl = timMessage.faceUrl
			group = isGroup
			id = timMessage.msgID
			this.tiMessage = timMessage
			showName = if (!isGroup || timMessage.nameCard.isNullOrEmpty()) {
				if (!timMessage.nickName.isNullOrEmpty()) timMessage.nickName else if (!timMessage.sender.isNullOrEmpty()) timMessage.sender else ""
			} else timMessage.nameCard
			
			when (timMessage.elemType) {
				V2TIMMessage.V2TIM_ELEM_TYPE_CUSTOM -> {
					val customElem = timMessage.customElem
					val data = customElem.data
					if (data != null) {
						when (val string = String(data)) {
							GROUP_CREATE -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_CREATE
								extra = covert2HTMLString(showName)
							}
							GROUP_DELETE -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_DELETE
								extra = string
							}
							else -> {
								msgType = MessageInfoModel.MSG_TYPE_CUSTOM
								extra = string
							}
						}
					}
				}
				V2TIMMessage.V2TIM_ELEM_TYPE_GROUP_TIPS -> {
					val groupTipsElem = timMessage.groupTipsElem
					if (groupTipsElem != null) {
						var user = ""
						val memberList = groupTipsElem.memberList
						Log.d("messageTipsTag", "memberList:${memberList.isNullOrEmpty()}")
						if (!memberList.isNullOrEmpty()) {
							for (i in memberList.indices) {
								val v2TIMGroupMemberInfo = memberList[i]
								if (i == 0) {
									user = if (!v2TIMGroupMemberInfo.nameCard.isNullOrEmpty()) v2TIMGroupMemberInfo.nameCard
									else if (!v2TIMGroupMemberInfo.nickName.isNullOrEmpty()) v2TIMGroupMemberInfo.nickName
									else v2TIMGroupMemberInfo.userID ?: ""
									Log.d("messageTipsTag", "nameCard:${v2TIMGroupMemberInfo.nameCard},nickName:${v2TIMGroupMemberInfo.nickName}")
								} else {
									if (i == 2 && memberList.size > 3) {
										user += "等"
										break
									} else {
										user = "$user，" + if (!v2TIMGroupMemberInfo.nameCard.isNullOrEmpty()) v2TIMGroupMemberInfo.nameCard
										else if (!v2TIMGroupMemberInfo.nickName.isNullOrEmpty()) v2TIMGroupMemberInfo.nickName
										else v2TIMGroupMemberInfo.userID ?: ""
									}
								}
							}
						} else user = groupTipsElem.opMember?.userID ?: ""
						var message = covert2HTMLString(user)
						when (groupTipsElem.type) {
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_INVITE,
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_JOIN -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_JOIN
								message += "加入群组"
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_QUIT -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_QUITE
								message += "退出群组"
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_KICKED -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_KICK
								message += "被踢出群组"
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_SET_ADMIN -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
								message += "被设置管理员"
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_CANCEL_ADMIN -> {
								msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
								message += "被取消管理员"
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_GROUP_INFO_CHANGE -> {
								val groupChangeInfoList = groupTipsElem.groupChangeInfoList
								if (!groupChangeInfoList.isNullOrEmpty()) {
									for (i in 0 until groupChangeInfoList.size) {
										val groupChange = groupChangeInfoList[i]
										when (groupChange.type) {
											V2TIMGroupChangeInfo.V2TIM_GROUP_INFO_CHANGE_TYPE_NAME -> {
												msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NAME
												message = message + "修改群名称为\"" + groupChange.value + "\""
											}
											V2TIMGroupChangeInfo.V2TIM_GROUP_INFO_CHANGE_TYPE_NOTIFICATION -> {
												msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
												message = message + "修改群公告为\"" + groupChange.value + "\""
											}
											V2TIMGroupChangeInfo.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER -> {
												msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
												message = message + "转让群主给\"" + groupChange.value + "\""
											}
											V2TIMGroupChangeInfo.V2TIM_GROUP_INFO_CHANGE_TYPE_FACE_URL -> {
												msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
												message += "修改了群头像"
											}
											V2TIMGroupChangeInfo.V2TIM_GROUP_INFO_CHANGE_TYPE_INTRODUCTION -> {
												msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
												message = message + "修改群介绍为\"" + groupChange.value + "\""
											}
										}
										if (i < groupChangeInfoList.size - 1) message = "$message、"
									}
								}
							}
							V2TIMGroupTipsElem.V2TIM_GROUP_TIPS_TYPE_MEMBER_INFO_CHANGE -> {
								if (!groupTipsElem.memberChangeInfoList.isNullOrEmpty()) {
									val muteTime = groupTipsElem.memberChangeInfoList[0].muteTime
									message = if (muteTime > 0) {
										msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
										message + "被禁言\"" + TimeUtils.formatSeconds(muteTime) + "\""
									} else {
										msgType = MessageInfoModel.MSG_TYPE_GROUP_MODIFY_NOTICE
										message + "被取消禁言"
									}
								}
							}
						}
						if (message.isEmpty()) return null
						extra = message
					}
				}
				else -> {
					when (timMessage.elemType) {
						V2TIMMessage.V2TIM_ELEM_TYPE_TEXT -> extra = timMessage.textElem?.text
						V2TIMMessage.V2TIM_ELEM_TYPE_FACE -> extra = ("[自定义表情]")
						V2TIMMessage.V2TIM_ELEM_TYPE_SOUND -> {
							val soundElemEle = timMessage.soundElem
							if (soundElemEle != null) {
								soundElemEle.getUrl(object : V2TIMValueCallback<String?> {
									override fun onError(p0: Int, p1: String?)=Unit
									override fun onSuccess(p0: String?) {
										dataPath = p0
									}
								})
								if (self) dataPath = soundElemEle.path
								duration =soundElemEle.duration
								extra = "[语音]"
							}
						}
						V2TIMMessage.V2TIM_ELEM_TYPE_IMAGE -> {
							val imageEle = timMessage.imageElem
							if (imageEle != null) {
								dataPath = imageEle.path
								val imageList = imageEle.imageList
								if (!imageList.isNullOrEmpty()){
									imageList.forEach {
										if (it.type == TIMImageType.Thumb.value()) {
											width = it.width
											height = it.height
											snapshotPath = it.url
											Log.d("imageTag", "Thumb-type:${it.type},width:${it.width},height:${it.height}")
											return@forEach
										}else if (it.type == TIMImageType.Original.value()){
											dataPath = it.url
										}
									}
								}
								Log.d("imageTag", "dataPath:$dataPath")
							}
							extra = "[图片]"
						}
						V2TIMMessage.V2TIM_ELEM_TYPE_FILE -> {
							val fileElem = timMessage.fileElem
							fileElem?.getUrl(object : V2TIMValueCallback<String?> {
								override fun onError(p0: Int, p1: String?)=Unit
								override fun onSuccess(p0: String?) {
									dataPath = p0
								}
							})
							extra = "[文件]"
						}
						V2TIMMessage.V2TIM_ELEM_TYPE_VIDEO -> {
							val videoElem = timMessage.videoElem
							if (videoElem != null ) {
								videoElem.getSnapshotUrl(object : V2TIMValueCallback<String?> {
									override fun onError(p0: Int, p1: String?)=Unit
									
									override fun onSuccess(p0: String?) {
										snapshotPath = p0?:""
										Log.d("imageTag", "snapshotPath:$snapshotPath,dataPath:$dataPath")
									}
								})
								videoElem.getVideoUrl(object : V2TIMValueCallback<String?> {
									override fun onError(p0: Int, p1: String?)=Unit
									override fun onSuccess(p0: String?) {
										dataPath = p0
										Log.d("imageTag", "snapshotPath:$snapshotPath,dataPath:$dataPath")
									}
								})
								duration = videoElem.duration
								width = videoElem.snapshotWidth
								height =videoElem.snapshotHeight
							}
							extra = "[视频]"
							Log.d("imageTag", "snapshotPath:$snapshotPath,dataPath:$dataPath")
							Log.d("imageTag", "duration:$duration,width:$width,height:$height")
						}
					}
					msgType = tIMElemType2MessageInfoType(timMessage.elemType)
				}
			}
			Log.d("chatTag", "msgType:${msgType}")
			if (timMessage.status == V2TIMMessage.V2TIM_MSG_STATUS_LOCAL_REVOKED) {
				status = MessageInfoModel.MSG_STATUS_REVOKE
				msgType = MessageInfoModel.MSG_STATUS_REVOKE
				extra = "消息撤回"
			} else {
				if (self) {
					status = when (timMessage.status) {
						V2TIMMessage.V2TIM_MSG_STATUS_SEND_SUCC -> MessageInfoModel.MSG_STATUS_SEND_SUCCESS
						V2TIMMessage.V2TIM_MSG_STATUS_SENDING -> MessageInfoModel.MSG_STATUS_SENDING
						else -> MessageInfoModel.MSG_STATUS_SEND_FAIL
					}
				}
			}
			return this
		})
	}
	
	private fun tIMElemType2MessageInfoType(type: Int): Int {
		when (type) {
			V2TIMMessage.V2TIM_ELEM_TYPE_TEXT -> return MessageInfoModel.MSG_TYPE_TEXT
			V2TIMMessage.V2TIM_ELEM_TYPE_IMAGE -> return MessageInfoModel.MSG_TYPE_IMAGE
			V2TIMMessage.V2TIM_ELEM_TYPE_SOUND -> return MessageInfoModel.MSG_TYPE_AUDIO
			V2TIMMessage.V2TIM_ELEM_TYPE_VIDEO -> return MessageInfoModel.MSG_TYPE_VIDEO
			V2TIMMessage.V2TIM_ELEM_TYPE_FILE -> return MessageInfoModel.MSG_TYPE_FILE
			V2TIMMessage.V2TIM_ELEM_TYPE_LOCATION -> return MessageInfoModel.MSG_TYPE_LOCATION
			V2TIMMessage.V2TIM_ELEM_TYPE_FACE -> return MessageInfoModel.MSG_TYPE_CUSTOM_FACE
			V2TIMMessage.V2TIM_ELEM_TYPE_GROUP_TIPS -> return MessageInfoModel.MSG_TYPE_TIPS
			V2TIMMessage.V2TIM_ELEM_TYPE_CUSTOM -> return MessageInfoModel.MSG_TYPE_CUSTOM
		}
		return MessageInfoModel.MSG_TYPE_TEXT
	}
	
	private fun covert2HTMLString(original: String?): String {
		if (original.isNullOrEmpty()) return ""
		return "\"<font color=\"#5B6B92\">$original</font>\""
	}
	
	private fun getFileSavePath(context: Context, uuid: String?): String {
		return Utils.getFileCachePath(context) + File.separator + uuid
	}
	
}