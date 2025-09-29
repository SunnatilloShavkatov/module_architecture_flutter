-ignorewarnings
-keep class * {
    public private *;
}

#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class kotlin.Metadata { *; }

-keepattributes *Annotation*
-keepattributes Signature
-dontwarn com.squareup.**
-keep class com.squareup.** { *; }
-dontwarn com.parse.ParseOkHttpClient**
-keep class com.parse.ParseOkHttpClient** { *; }
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry
-dontwarn java.lang.invoke.StringConcatFactory

# Preserve essential reflection classes
-keep class java.lang.reflect.** { *; }
-keep class com.google.common.reflect.** { *; }
-dontwarn java.lang.reflect.AnnotatedType
-dontwarn java.lang.reflect.AnnotatedTypeVariable
-dontwarn com.google.android.gms.auth.api.credentials.Credential
-dontwarn com.google.android.gms.auth.api.credentials.CredentialsApi
-dontwarn j$.util.**

# Keep asInterface method cause it's accessed from SafeParcel
-keepattributes InnerClasses
-keepclassmembers interface * extends android.os.IInterface {
    public static class *;
}
-keep public class * extends android.os.Binder { public static *; }

# Keep Dart-implemented methods
-keepclassmembers class * {
    *** getters();
    *** setters();
    *** invoke(...);
}

# === Flutter plugin and engine classes (always needed) ===
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# === Keep classes used for platform channels ===
-keep class ** implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { *; }
-keep class ** implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class ** implements io.flutter.plugin.common.EventChannel$StreamHandler { *; }

# === Keep classes with native methods ===
-keepclasseswithmembers class * {
    native <methods>;
}

# === Keep all annotations (safe default) ===
-keepattributes *Annotation*

# === This section was moved up to avoid duplication ===

# === Ignore missing Play Core classes (Flutter engine references) ===
# This is needed when using just_audio 0.10.2+ with AGP 8.x
# The Flutter engine references Play Core classes but doesn't include the dependency
# We use -dontwarn instead of adding the deprecated Play Core library
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Specifically ignore the classes mentioned in the error
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
