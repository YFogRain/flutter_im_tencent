package com.example.tencent_im

/**
 *  Create by rain
 *  Date: 2020/10/15
 */
object TimeUtils {
	fun formatSeconds(seconds: Long): String{
		var timeStr = seconds.toString() + "秒"
		if (seconds > 60) {
			val second = seconds % 60
			var min = seconds / 60
			timeStr = min.toString() + "分" + second + "秒"
			if (min > 60) {
				min = seconds / 60 % 60
				var hour = seconds / 60 / 60
				timeStr = hour.toString() + "小时" + min + "分" + second + "秒"
				if (hour % 24 == 0L) {
					val day = seconds / 60 / 60 / 24
					timeStr = day.toString() + "天"
				} else if (hour > 24) {
					hour = seconds / 60 / 60 % 24
					val day = seconds / 60 / 60 / 24
					timeStr = day.toString() + "天" + hour + "小时" + min + "分" + second + "秒"
				}
			}
		}
		return timeStr
	}
}