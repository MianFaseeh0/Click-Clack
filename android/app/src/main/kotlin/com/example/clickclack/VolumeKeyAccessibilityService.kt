package com.example.clickclack

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.os.Handler
import android.os.Looper
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

/**
 * Requires the user to manually enable this service under
 * Settings > Accessibility > ClickClack — Android does not allow apps to
 * turn this on for themselves. See QuickCaptureService.openAccessibilitySettings
 * on the Dart side for the shortcut into that screen.
 */
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

        when (event.action) {
            KeyEvent.ACTION_DOWN -> {
                // repeatCount == 0 is the initial press; the OS then fires
                // repeated ACTION_DOWN events with repeatCount > 0 for as
                // long as the key stays held — ignore those, we only need
                // to schedule the trigger once per physical hold.
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
        // Never consume the key — volume still changes normally while held.
        return false
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {}
}
