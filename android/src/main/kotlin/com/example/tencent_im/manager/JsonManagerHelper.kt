package com.example.tencent_im.manager

import android.text.TextUtils
import com.google.gson.Gson

class JsonManagerHelper {
    private var gson: Gson? = null

    companion object {
        private var instance: JsonManagerHelper? = null
            get() {
                if (field == null) field = JsonManagerHelper()
                return field
            }

        fun getHelper(): JsonManagerHelper {
            return instance!!
        }
    }

    fun getGs(): Gson {
        if (gson == null) {
            gson = Gson()
        }
        return gson!!
    }

    fun <T>strToData(str: String?, clazz: Class<T>?): T? {
        if (str.isNullOrEmpty() || clazz == null) {
            return null
        }
        return getGs().fromJson(str, clazz)

    }

    fun <T>dataToStr(baseBean: T?): String? {
        if (baseBean == null) return null
        return getGs().toJson(baseBean)
    }

}