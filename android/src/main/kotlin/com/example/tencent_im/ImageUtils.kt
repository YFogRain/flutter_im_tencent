package com.example.tencent_im

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.os.Environment
import androidx.exifinterface.media.ExifInterface
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.util.*

/**
 *  Create by rain
 *  Date: 2020/10/14
 */
object ImageUtils {
	fun saveBitmap(context: Context,b: Bitmap): String {
		val fileImageCachePath = getFileImageCachePath(context)
		val jpegName = fileImageCachePath + File.separator + UUID.randomUUID().toString() + ".jpg"
		return try {
			val font = FileOutputStream(jpegName)
			val bos = BufferedOutputStream(font)
			b.compress(Bitmap.CompressFormat.JPEG, 100, bos)
			bos.flush()
			bos.close()
			jpegName
		} catch (e: IOException) {
			""
		}
	}
	
	private fun getFileImageCachePath(context: Context): String {
		val result = File(context.externalCacheDir, Environment.DIRECTORY_PICTURES)
		if (!result.exists()) {
			result.mkdirs()
		}
		return result.path
	}
	
	fun getImageSize(url: String): IntArray {
		val size = IntArray(2)
		try {
			val opts = BitmapFactory.Options()
			//只请求图片宽高，不解析图片像素(请求图片属性但不申请内存，解析bitmap对象，该对象不占内存)
			opts.inJustDecodeBounds = true
			val onlyBoundsOptions = BitmapFactory.Options()
			onlyBoundsOptions.inJustDecodeBounds = true
			BitmapFactory.decodeFile(url, opts)
			//获取屏幕的宽和高
			val screenWidth = opts.outWidth
			val screenHeight = opts.outHeight
			
			val bitmapDegree = getBitmapDegree(url)
			if (bitmapDegree == 0) {
				size[0] = screenWidth
				size[1] = screenHeight
			} else {
				//图片分辨率以480x800为标准
				val hh = 800f //这里设置高度为800f
				val ww = 480f //这里设置宽度为480f
				val be = if (screenWidth > screenHeight && screenWidth > ww) {
					//如果宽度大的话根据宽度固定大小缩放
					(screenWidth / ww).toInt()
				} else if (screenWidth < screenHeight && screenHeight > hh) {
					//如果高度高的话根据宽度固定大小缩放
					(screenHeight / hh).toInt()
				} else 1
				
				//设置缩放比例
				opts.inSampleSize = be
				//为图片申请内存
				opts.inJustDecodeBounds = false
				opts.inPreferredConfig = Bitmap.Config.ARGB_8888 //optional
				val decodeFile1 =
						rotateBitmapByDegree(BitmapFactory.decodeFile(url, opts), degree = bitmapDegree)
				size[0] = decodeFile1.width
				size[1] = decodeFile1.height
			}
		} catch (e: Exception) {
			e.printStackTrace()
		}
		
		return size
	}
	
	/**
	 * 将图片按照某个角度进行旋转
	 *
	 * @param bm     需要旋转的图片
	 * @param degree 旋转角度
	 * @return 旋转后的图片
	 */
	private fun rotateBitmapByDegree(bm: Bitmap, degree: Int): Bitmap {
		var returnBm: Bitmap? = null
		
		// 根据旋转角度，生成旋转矩阵
		val matrix = Matrix()
		matrix.postRotate(degree.toFloat())
		try {
			// 将原始图片按照旋转矩阵进行旋转，并得到新的图片
			returnBm = Bitmap.createBitmap(bm, 0, 0, bm.width, bm.height, matrix, true)
		} catch (e: OutOfMemoryError) {
		}
		if (returnBm == null) {
			returnBm = bm
		}
		if (bm != returnBm) {
			bm.recycle()
		}
		return returnBm
	}
	
	/**
	 * 读取图片的旋转的角度
	 */
	private fun getBitmapDegree(url: String): Int {
		var degree = 0
		try {
			// 从指定路径下读取图片，并获取其EXIF信息
			val exifInterface = ExifInterface(url)
			// 获取图片的旋转信息
			val orientation: Int = exifInterface.getAttributeInt(
					ExifInterface.TAG_ORIENTATION,
					ExifInterface.ORIENTATION_NORMAL
			)
			when (orientation) {
				ExifInterface.ORIENTATION_ROTATE_90 -> degree = 90
				ExifInterface.ORIENTATION_ROTATE_180 -> degree = 180
				ExifInterface.ORIENTATION_ROTATE_270 -> degree = 270
			}
		} catch (e: IOException) {
			e.printStackTrace()
		}
		return degree
	}
	
}