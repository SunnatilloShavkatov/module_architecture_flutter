package uz.nasiya.platform_methods

import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.media.AudioAttributes

class Vibration(private val vibrator: Vibrator) {

    @Suppress("DEPRECATION")
    fun vibrate(duration: Long, amplitude: Int) {
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM).build()
                if (vibrator.hasAmplitudeControl()) {
                    vibrator.vibrate(
                        VibrationEffect.createOneShot(duration, amplitude), audioAttributes
                    )
                } else {
                    vibrator.vibrate(
                        VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE),
                        audioAttributes
                    )
                }
            } else {
                vibrator.vibrate(duration)
            }
        }
    }

    @Suppress("DEPRECATION")
    fun vibrate(pattern: List<Int>, repeat: Int) {
        val patternLong = pattern.map { it.toLong() }.toLongArray()
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM).build()
                vibrator.vibrate(
                    VibrationEffect.createWaveform(patternLong, repeat), audioAttributes
                )
            } else {
                vibrator.vibrate(patternLong, repeat)
            }
        }
    }

    @Suppress("DEPRECATION")
    fun vibrate(pattern: List<Int>, repeat: Int, intensities: List<Int>) {
        val patternLong = pattern.map { it.toLong() }.toLongArray()
        val intensitiesArray = intensities.toIntArray()
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM).build()
                if (vibrator.hasAmplitudeControl()) {
                    vibrator.vibrate(
                        VibrationEffect.createWaveform(patternLong, intensitiesArray, repeat),
                        audioAttributes
                    )
                } else {
                    vibrator.vibrate(
                        VibrationEffect.createWaveform(patternLong, repeat), audioAttributes
                    )
                }
            } else {
                vibrator.vibrate(patternLong, repeat)
            }
        }
    }

    fun getVibrator(): Vibrator = vibrator
}