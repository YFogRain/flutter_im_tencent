package com.example.tencent_im

import android.content.Context
import android.os.Environment
import java.io.File

/**
 *  Create by rain
 *  Date: 2020/10/15
 */
object Utils {
	fun getFileImageCachePath(context: Context): String {
		val result = File(context.externalCacheDir, Environment.DIRECTORY_PICTURES)
		if (!result.exists()) {
			result.mkdirs()
		}
		return result.path
	}
	
	fun getFileCachePath(context: Context): String {
		val result = File(context.externalCacheDir, Environment.DIRECTORY_DOWNLOADS)
		if (!result.exists()) {
			result.mkdirs()
		}
		return result.path
	}
}