package com.example.clickclack

import android.accessibilityservice.AccessibilityService
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Shows/dismisses the quick-capture popup as a TYPE_ACCESSIBILITY_OVERLAY
 * window. That window type is specifically for active accessibility
 * services and does NOT require the separate "draw over other apps"
 * (SYSTEM_ALERT_WINDOW) permission — only an enabled AccessibilityService,
 * which the user already granted to get here.
 *
 * Deliberately skips the image field from AddNoteSheet — launching a
 * gallery picker from an accessibility overlay/service context isn't
 * reliable across OEMs. Attach an image later from inside the app instead.
 */
object QuickCaptureOverlay {
    // Must stay in the same order as NoteCategory in note_hive_model.dart —
    // this index is written straight into the Hive-backed enum.
    private val categories = listOf("Instagram", "Screenshots", "TikTok")

    private var activeView: View? = null

    fun show(service: AccessibilityService) {
        if (activeView != null) return // already showing, ignore re-trigger

        val wm = service.getSystemService(AccessibilityService.WINDOW_SERVICE) as WindowManager
        val root = LayoutInflater.from(service).inflate(R.layout.overlay_quick_capture, null)
        root.isClickable = true

        val card = root.findViewById<View>(R.id.quick_capture_card)
        card.background = GradientDrawable().apply {
            setColor(Color.parseColor("#131313"))
            cornerRadius = 24f
        }
        card.isClickable = true // swallow taps so they don't fall through to the dismiss scrim

        val editText = root.findViewById<EditText>(R.id.quick_capture_text)
        val chipRow = root.findViewById<LinearLayout>(R.id.quick_capture_chip_row)
        var selectedIndex = 0

        fun refreshChips() {
            for (i in 0 until chipRow.childCount) {
                val chip = chipRow.getChildAt(i) as TextView
                val selected = i == selectedIndex
                chip.setTextColor(if (selected) Color.BLACK else Color.WHITE)
                chip.background = GradientDrawable().apply {
                    cornerRadius = 40f
                    if (selected) {
                        setColor(Color.parseColor("#E8622C"))
                    } else {
                        setColor(Color.TRANSPARENT)
                        setStroke(2, Color.parseColor("#88FFFFFF"))
                    }
                }
            }
        }

        categories.forEachIndexed { index, label ->
            val chip = TextView(service).apply {
                text = label
                textSize = 13f
                setPadding(28, 16, 28, 16)
                setOnClickListener {
                    selectedIndex = index
                    refreshChips()
                }
            }
            val params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
            params.marginEnd = 12
            chipRow.addView(chip, params)
        }
        refreshChips()

        fun dismiss() {
            wm.removeView(root)
            activeView = null
        }

        root.setOnClickListener { dismiss() } // tap outside the card

        root.findViewById<View>(R.id.quick_capture_cancel).setOnClickListener { dismiss() }
        root.findViewById<View>(R.id.quick_capture_save).setOnClickListener {
            val text = editText.text.toString().trim()
            if (text.isNotEmpty()) {
                QuickCaptureStore.append(service.applicationContext, text, selectedIndex)
            }
            dismiss()
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.CENTER
        params.softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE

        wm.addView(root, params)
        activeView = root
    }
}
