package com.example.clickclack

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Tiny on-disk JSON queue bridging the accessibility overlay (which may run
 * with no Flutter engine alive at all) and the Flutter app, which reads and
 * clears it on startup / resume via MainActivity's MethodChannel.
 *
 * Deliberately not piggybacking on the shared_preferences plugin's file —
 * its on-disk format is a plugin implementation detail, not a contract
 * worth writing native code against.
 */
object QuickCaptureStore {
    private const val FILE_NAME = "pending_quick_captures.json"

    @Synchronized
    fun append(context: Context, text: String, categoryIndex: Int) {
        val file = File(context.filesDir, FILE_NAME)
        val array = if (file.exists()) JSONArray(file.readText()) else JSONArray()
        array.put(
            JSONObject().apply {
                put("text", text)
                put("category", categoryIndex)
                put("createdAt", System.currentTimeMillis())
            }
        )
        file.writeText(array.toString())
    }

    /** Called from Flutter. Reads everything queued, then clears the file so a repeat call is a no-op. */
    @Synchronized
    fun readAndClear(context: Context): List<Map<String, Any>> {
        val file = File(context.filesDir, FILE_NAME)
        if (!file.exists()) return emptyList()

        val array = JSONArray(file.readText())
        val result = mutableListOf<Map<String, Any>>()
        for (i in 0 until array.length()) {
            val obj = array.getJSONObject(i)
            result.add(
                mapOf(
                    "text" to obj.getString("text"),
                    "category" to obj.getInt("category"),
                    "createdAt" to obj.getLong("createdAt"),
                )
            )
        }
        file.delete()
        return result
    }
}
