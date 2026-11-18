package uz.plugin.platform_methods

import kotlinx.coroutines.runBlocking
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse

/*
 * Unit tests for the Kotlin side of the Native Interop host API.
 *
 * Once you have built the plugin's example app, run them with
 * `./gradlew testDebugUnitTest` in the `example/android/` directory.
 */
internal class PlatformMethodsPluginTest {
    @Test
    fun isReviewAvailable_notAttached_returnsFalse() = runBlocking {
        val plugin = PlatformMethodsPlugin()

        assertFalse(plugin.isReviewAvailable())
    }

    @Test
    fun getDeviceId_notAttached_throwsNotAttached() = runBlocking {
        val plugin = PlatformMethodsPlugin()

        val error = assertFailsWith<PlatformMethodsError> { plugin.getDeviceId() }

        assertEquals("ERROR_NOT_ATTACHED", error.code)
    }

    @Test
    fun requestReview_notAttached_throwsNotAttached() = runBlocking {
        val plugin = PlatformMethodsPlugin()

        val error = assertFailsWith<PlatformMethodsError> { plugin.requestReview() }

        assertEquals("ERROR_NOT_ATTACHED", error.code)
    }
}
