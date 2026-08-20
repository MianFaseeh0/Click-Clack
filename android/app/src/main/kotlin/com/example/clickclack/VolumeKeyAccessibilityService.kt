package com.example.clickclack

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class VolumeKeyAccessibilityService : AccessibilityService() {

    private val handler = Handler(Looper.getMainLooper())
    private var pendingTrigger: Runnable? = null
    private val holdDurationMs = 5000L

    override fun onServiceConnected() {
        serviceInfo = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPES_ALL_MASK
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_REQUEST_FILTER_KEY_EVENTS
        }
    }

    override fun onKeyEvent(event: KeyEvent): Boolean {
        if (event.keyCode != KeyEvent.KEYCODE_VOLUME_UP) return false
        Log.d("QuickCapture", "volume key event: action=${event.action} repeat=${event.repeatCount}")

        when (event.action) {
            KeyEvent.ACTION_DOWN -> {
                if (event.repeatCount == 0 && pendingTrigger == null) {
                    val runnable = Runnable {
                        QuickCaptureOverlay.show(this)
                        pendingTrigger = null
                    }
                    pendingTrigger = runnable
                    handler.postDelayed(runnable, holdDurationMs)
                }
            }
            KeyEvent.ACTION_UP -> {
                pendingTrigger?.let { handler.removeCallbacks(it) }
                pendingTrigger = null
            }
        }
        return false
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {}
}