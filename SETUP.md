# Quick capture (volume-up hold) — setup

Drop the `lib/` and `android/` files from this zip into your project (they
overwrite `main.dart` and `notes_list_screen.dart`, add new files
elsewhere). Three things need manual attention:

## 1. Fix the package name

Everything under `android/app/src/main/kotlin/com/example/clickclack/` is
written for `com.example.clickclack`. Check your real `applicationId` in
`android/app/build.gradle` — if it's different:
- move the 4 `.kt` files into the matching folder path
- update `package com.example.clickclack` at the top of each to match

## 2. AndroidManifest.xml

Add this `<service>` inside your existing `<application>` tag (next to your
`<activity>` entry) — don't overwrite the whole manifest, just merge this in:

```xml
<service
    android:name=".VolumeKeyAccessibilityService"
    android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
    android:exported="false">
    <intent-filter>
        <action android:name="android.accessibilityservice.AccessibilityService" />
    </intent-filter>
    <meta-data
        android:name="android.accessibilityservice.config"
        android:resource="@xml/accessibility_service_config" />
</service>
```

No new `<uses-permission>` needed — `TYPE_ACCESSIBILITY_OVERLAY` doesn't
require `SYSTEM_ALERT_WINDOW`, only an enabled accessibility service.

## 3. strings.xml

Add this line to `android/app/src/main/res/values/strings.xml` (create the
file with a `<resources>` wrapper if you don't have one yet):

```xml
<string name="accessibility_service_description">Lets ClickClack detect a 5-second volume-up hold to open quick capture, anywhere on your phone.</string>
```

## 4. MainActivity.kt

If yours already has custom code, don't overwrite it — just copy the
`channelName` constant and the `configureFlutterEngine` override from the
one in this zip into your existing class.

## How the user turns it on

Accessibility services can't be enabled programmatically — Android requires
a manual toggle. The app now has a small gear icon next to the "+" on the
notes screen that jumps straight to
`Settings > Accessibility > ClickClack`; walk your fiancée-you-the-user
through flipping it on once after install.

## Known rough edges to test on a real device

- **OEM restrictions**: Samsung/Xiaomi/Oppo etc. sometimes throttle or kill
  background accessibility services more aggressively than stock Android.
  Test on whatever device this actually needs to run on, not just an
  emulator.
- **Keyboard behavior over the overlay**: `TYPE_ACCESSIBILITY_OVERLAY` +
  soft keyboard interaction varies a bit across OEM skins. If the keyboard
  covers the text field or the card jumps oddly, that's the first place to
  tweak (`softInputMode` in `QuickCaptureOverlay.kt`).
- **No image field in the overlay** — by design (see comment in
  `QuickCaptureOverlay.kt`). If you want it anyway, the more reliable path
  is turning the overlay into a translucent `Activity` instead of an
  accessibility-service window, which can then launch the gallery picker
  normally — a bigger change, happy to build it if you hit this wall.
