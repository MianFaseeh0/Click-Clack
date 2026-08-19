package com.example.clickclack

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// NOTE: if your MainActivity.kt already has customizations, don't replace
// the whole file — just copy the CHANNEL_NAME constant and the
// configureFlutterEngine override below into your existing class.
class MainActivity : FlutterActivity() {
    private val channelName = "clickclack/quick_capture"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPendingCaptures" -> result.success(QuickCaptureStore.readAndClear(applicationContext))
                "openAccessibilitySettings" -> {
                    startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
