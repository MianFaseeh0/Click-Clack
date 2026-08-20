package com.example.clickclack

import android.accessibilityservice.AccessibilityService
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView

object QuickCaptureOverlay {
    private val categories = listOf("Instagram", "Screenshots", "TikTok")

    private var activeView: View? = null

    fun show(service: AccessibilityService) {
        Log.d("QuickCapture", "showing overlay")
        if (activeView != null) return // already showing, ignore re-trigger

        val wm = service.getSystemService(AccessibilityService.WINDOW_SERVICE) as WindowManager
        val root = LayoutInflater.from(service).inflate(R.layout.overlay_quick_capture, null)
        root.isClickable = true

        val card = root.findViewById<View>(R.id.quick_capture_card)
        card.background = GradientDrawable().apply {
            setColor(Color.parseColor("#131313"))
            cornerRadius = 24f
        }
        card.isClickable = true

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

        root.setOnClickListener { dismiss() }

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