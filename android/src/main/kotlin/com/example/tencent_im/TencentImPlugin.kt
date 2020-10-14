package com.example.tencent_im

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.tencent.imsdk.v2.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TencentImPlugin */
class TencentImPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
	private lateinit var imMethodChannel: MethodChannel
	private lateinit var imEventChannel: EventChannel
	private var eventSink: EventSink? = null
	private lateinit var context: Context
	override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
		context = flutterPluginBinding.applicationContext
		imMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "tencent_im/dim_method")
		imMethodChannel.setMethodCallHandler(this)
		
		imEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "tencent_im/dim_event")
		imEventChannel.setStreamHandler(this)
	}
	
	override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
		when (call.method) {
			"initIM" -> initIM(call.argument<Int>("app_id") ?: -1, result) //初始化登錄
			"isLoginIM" -> isLoginIM(result) // 是否已经登录IM帐号
			"loginIM" -> loginIM(call.argument<String>("user_id"), call.argument<String>("user_key"), result)//登录
			"loginOut" -> loginOutIM(result) //退出登录
			"loginUser" -> result.success(V2TIMManager.getInstance().loginUser) //登录的用户
			"getConversations" -> getConversations(call.argument<Int>("startIndex")
					?: 0, call.argument<Int>("endIndex") ?: 0, result)//获取会话列表
			"deleteConversation" -> deleteConversation(call.argument<String>("conversationId"), result) //删除会话
			
			"sendTextMessage" -> sendMessage(result, MessageInfoUtil.buildTextMessage(call.argument<String>("content")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送文本消息
			
			"sendImageMessage" -> sendMessage(result, MessageInfoUtil.buildImageMessage(call.argument<String>("imagePath")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送图片消息
			
			"sendSoundMessage" -> sendMessage(result, MessageInfoUtil.buildAudioMessage(call.argument<String>("audioPath"), call.argument<Int>("duration")
					?: 0),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送语音消息
			
			"sendVideoMessage" -> sendMessage(result, MessageInfoUtil.buildVideoMessage(context, call.argument<String>("videoPath")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送視頻消息
			
			"sendFileMessage" -> sendMessage(result, MessageInfoUtil.buildFileMessage(call.argument<String>("filePath")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送文件消息
			
			"sendCustomFaceMessage" -> sendMessage(result, MessageInfoUtil.buildCustomFaceMessage(call.argument<String>("faceName")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送自定义表情消息
			
			"sendCustomMessage" -> sendMessage(result, MessageInfoUtil.buildCustomMessage(call.argument<String>("customStr")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送自定义消息
			
			"sendAtMessage" -> sendMessage(result, MessageInfoUtil.buildTextAtMessage(call.argument<MutableList<String>>("atUserList"), call.argument<String>("message")),
					call.argument<Boolean>("isGroup") ?: false,
					call.argument<String>("imId"),
					call.argument<Boolean>("retry") ?: false) //发送@消息
			
			"loadChatHistory" -> loadChatHistory(call.argument<String>("imId"),call.argument<Int>("size")?:20, call.argument<Boolean>("isGroup")
					?: false, result)//加载历史消息
			
			
			else -> result.notImplemented()
		}
	}
	
	override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
		imMethodChannel.setMethodCallHandler(null)
		imEventChannel.setStreamHandler(null)
	}
	
	override fun onListen(arguments: Any?, events: EventSink?) {
		this.eventSink = events
	}
	
	override fun onCancel(arguments: Any?) {
		this.eventSink = null
	}
	
	/**
	 * 初始化IM
	 */
	private fun initIM(appId: Int, result: Result) {
		val config = V2TIMSDKConfig()
		config.setLogLevel(V2TIMSDKConfig.V2TIM_LOG_DEBUG)
		V2TIMManager.getInstance().initSDK(context, appId, config, object : V2TIMSDKListener() {
			override fun onConnecting() = Unit // 正在连接到腾讯云服务器
			
			// 已经成功连接到腾讯云服务器
			override fun onConnectSuccess() {
				result.success(true)
				Log.d("IMTag", "onConnectSuccess")
			}
			
			// 连接腾讯云服务器失败
			override fun onConnectFailed(code: Int, error: String?) {
				Log.d("IMTag", "onConnectFailed:$error,code:$code")
				result.success(false)
			}
		})
	}
	
	/**
	 * 判断是否登录
	 */
	private fun isLoginIM(result: Result) {
		val loginStatus = V2TIMManager.getInstance().loginStatus
		result.success(loginStatus == V2TIMManager.V2TIM_STATUS_LOGINING || loginStatus == V2TIMManager.V2TIM_STATUS_LOGINED)
	}
	
	/**
	 * 登录IM
	 */
	private fun loginIM(userId: String?, userKey: String?, result: Result) {
		V2TIMManager.getInstance().login(userId, userKey, object : V2TIMCallback {
			override fun onError(p0: Int, p1: String?) = result.success(false)
			override fun onSuccess() = result.success(true)
		})
	}
	
	/**
	 * 退出登录
	 */
	private fun loginOutIM(result: Result) {
		V2TIMManager.getInstance().logout(object : V2TIMCallback {
			override fun onError(p0: Int, p1: String?) = result.success(false)
			override fun onSuccess() = result.success(true)
		})
	}
	
	/**
	 * 获取会话列表
	 */
	private fun getConversations(startIndex: Int, endIndex: Int, result: Result) {
		V2TIMManager.getConversationManager().getConversationList(startIndex.toLong(), endIndex, object : V2TIMSendCallback<V2TIMConversationResult?> {
			override fun onSuccess(p0: V2TIMConversationResult?) {
				val lists: MutableList<Map<String, Any?>> = mutableListOf()
				p0?.conversationList?.forEach {
					lists.add(MessageInfoUtil.conversationToMap(it))
				}
				result.success(lists)
			}
			
			override fun onProgress(p0: Int) = Unit
			override fun onError(p0: Int, p1: String?) = result.success(null)
		})
	}
	
	/**
	 * 删除会话
	 */
	private fun deleteConversation(conversationId: String?, result: Result) {
		V2TIMManager.getConversationManager().deleteConversation(conversationId, object : V2TIMCallback {
			override fun onError(p0: Int, p1: String?) = result.success(false)
			override fun onSuccess() = result.success(true)
		})
	}
	
	/**
	 *  发送消息
	 */
	private fun sendMessage(result: Result, timMessage: V2TIMMessage?, isGroup: Boolean, chatId: String?, retry: Boolean = false) {
//		messageInfo.status = MessageInfo.MSG_STATUS_SENDING
//		addMessageInfo(messageInfo)
		if (chatId.isNullOrEmpty() || timMessage == null) {
			result.success(false)
			return
		}
		V2TIMManager.getMessageManager().sendMessage(timMessage,
				if (isGroup) null else chatId,
				if (isGroup) chatId else null,
				if (isGroup) 1 else 0,
				retry,
				null,
				object : V2TIMSendCallback<V2TIMMessage?> {
					override fun onSuccess(p0: V2TIMMessage?) = result.success(true)
					override fun onProgress(p0: Int) = Unit
					override fun onError(p0: Int, p1: String?) = result.success(false)
				})
	}
	
	/**
	 *  获取历史消息
	 */
	private fun loadChatHistory(imId: String?,size:Int =20, isGroup: Boolean, result: Result) {
			if (imId.isNullOrEmpty()){
				result.success(null)
				return
			}
		if (isGroup){
			V2TIMManager.getMessageManager().getGroupHistoryMessageList(imId,size,null,object : V2TIMValueCallback<MutableList<V2TIMMessage>?> {
				override fun onError(p0: Int, p1: String?) =result.success(null)
				
				override fun onSuccess(p0: MutableList<V2TIMMessage>?) {
					//TODO 转换数据
				}
			})
			return
		}
		V2TIMManager.getMessageManager().getC2CHistoryMessageList(imId,size,null,object : V2TIMValueCallback<MutableList<V2TIMMessage>?> {
			override fun onError(p0: Int, p1: String?)=result.success(null)
			
			override fun onSuccess(p0: MutableList<V2TIMMessage>?) {
				//TODO 转换数据
			}
		})
	}
	
}
