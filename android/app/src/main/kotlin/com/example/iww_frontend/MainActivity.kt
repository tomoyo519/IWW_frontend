package com.example.iww_frontend

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 기본 스플래시 화면을 바로 숨김
        window.setBackgroundDrawableResource(android.R.color.transparent)
    }
}