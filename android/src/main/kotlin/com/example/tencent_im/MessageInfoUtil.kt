package com.example.tencent_im

import android.util.Log
import com.tencent.imsdk.v2.V2TIMConversation
import com.tencent.imsdk.v2.V2TIMGroupAtInfo

/**
 *  Create by rain
 *  Date: 2020/10/14
 */
object MessageInfoUtil {
	fun conversationToMap( conversationData: V2TIMConversation): Map<String, Any?> {
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
	
}