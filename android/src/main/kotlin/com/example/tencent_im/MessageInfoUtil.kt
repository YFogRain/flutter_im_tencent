package com.example.tencent_im

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.util.Log
import com.tencent.imsdk.v2.V2TIMConversation
import com.tencent.imsdk.v2.V2TIMGroupAtInfo
import com.tencent.imsdk.v2.V2TIMManager
import com.tencent.imsdk.v2.V2TIMMessage
import java.io.File


/**
 *  Create by rain
 *  Date: 2020/10/14
 */
object MessageInfoUtil {
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
	fun buildVideoMessage(context: Context,videoPath: String?): V2TIMMessage? {
		if (videoPath.isNullOrEmpty()) return null
		val retriever = MediaMetadataRetriever()
		var mimeType:String?=null
		var bitmap:Bitmap?=null
		var duration =""
		try {
			retriever.setDataSource(videoPath)
			 duration = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: ""
			 mimeType = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE)
			 bitmap = retriever.frameAtTime
		} catch (e: Exception) {
			e.printStackTrace()
		}finally {
			retriever.release()
			
		}
		val imagePath = if (bitmap != null) ImageUtils.saveBitmap(context,bitmap) else null
		
		return V2TIMManager.getMessageManager().createVideoMessage(videoPath, mimeType, (duration.toLong() / 1000).toInt(), imagePath)
	}
	
	/**
	 * 创建一条音频消息
	 */
	fun buildAudioMessage(recordPath: String?,duration:Int): V2TIMMessage? {
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
}