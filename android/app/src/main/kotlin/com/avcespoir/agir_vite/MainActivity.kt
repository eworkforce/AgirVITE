package com.avcespoir.agir_vite

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.avcespoir.agir_vite/emergency"
        private const val REQUEST_SEND_SMS = 1001
        private const val REQUEST_CALL_PHONE = 1002
    }

    private var pendingSmsPhone: String? = null
    private var pendingSmsMessage: String? = null
    private var pendingSmsResult: MethodChannel.Result? = null

    private var pendingCallPhone: String? = null
    private var pendingCallResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "sendDirectSms" -> {
                        val phone = call.argument<String>("phone")
                        val message = call.argument<String>("message")
                        if (phone.isNullOrBlank() || message.isNullOrBlank()) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        if (ContextCompat.checkSelfPermission(
                                this,
                                Manifest.permission.SEND_SMS
                            ) == PackageManager.PERMISSION_GRANTED
                        ) {
                            sendSmsInternal(phone, message, result)
                        } else {
                            pendingSmsPhone = phone
                            pendingSmsMessage = message
                            pendingSmsResult = result
                            ActivityCompat.requestPermissions(
                                this,
                                arrayOf(Manifest.permission.SEND_SMS),
                                REQUEST_SEND_SMS
                            )
                        }
                    }

                    "callNumberDirectly" -> {
                        val phone = call.argument<String>("phone")
                        if (phone.isNullOrBlank()) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        if (ContextCompat.checkSelfPermission(
                                this,
                                Manifest.permission.CALL_PHONE
                            ) == PackageManager.PERMISSION_GRANTED
                        ) {
                            placeCallInternal(phone, direct = true, result = result)
                        } else {
                            pendingCallPhone = phone
                            pendingCallResult = result
                            ActivityCompat.requestPermissions(
                                this,
                                arrayOf(Manifest.permission.CALL_PHONE),
                                REQUEST_CALL_PHONE
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun sendSmsInternal(
        phone: String,
        message: String,
        result: MethodChannel.Result
    ) {
        try {
            val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                getSystemService(SmsManager::class.java) ?: SmsManager.getDefault()
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }
            val parts = smsManager.divideMessage(message)
            smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }

    private fun placeCallInternal(
        phone: String,
        direct: Boolean,
        result: MethodChannel.Result
    ) {
        try {
            val cleanPhone = phone.replace(" ", "")
            val action = if (direct) Intent.ACTION_CALL else Intent.ACTION_DIAL
            val intent = Intent(action, Uri.parse("tel:$cleanPhone"))
            startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            try {
                val cleanPhone = phone.replace(" ", "")
                val fallbackIntent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$cleanPhone"))
                startActivity(fallbackIntent)
                result.success(true)
            } catch (_: Exception) {
                result.success(false)
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            REQUEST_SEND_SMS -> {
                val phone = pendingSmsPhone
                val message = pendingSmsMessage
                val res = pendingSmsResult
                pendingSmsPhone = null
                pendingSmsMessage = null
                pendingSmsResult = null

                if (res != null && phone != null && message != null) {
                    val granted = grantResults.isNotEmpty() &&
                        grantResults[0] == PackageManager.PERMISSION_GRANTED
                    if (granted) {
                        sendSmsInternal(phone, message, res)
                    } else {
                        res.success(false)
                    }
                }
            }

            REQUEST_CALL_PHONE -> {
                val phone = pendingCallPhone
                val res = pendingCallResult
                pendingCallPhone = null
                pendingCallResult = null

                if (res != null && phone != null) {
                    val granted = grantResults.isNotEmpty() &&
                        grantResults[0] == PackageManager.PERMISSION_GRANTED
                    placeCallInternal(phone, direct = granted, result = res)
                }
            }
        }
    }
}
