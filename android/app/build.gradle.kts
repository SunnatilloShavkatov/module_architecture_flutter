import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystore = keystorePropertiesFile.exists()
if (hasKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "uz.shs.module_architecture_flutter"
    compileSdk = 36

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
    }

    android {
        sourceSets["main"].java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "uz.shs.module_architecture_flutter"
        minSdk = 24
        targetSdk = 36
        multiDexEnabled = true
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        ndk {
            // noinspection ChromeOsAbiSupport
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }
    }

    applicationVariants.all {
        outputs.all {
            val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl
            output.outputFileName =
                "module_archicture_mobile_${flutter.versionName}_(${flutter.versionCode}).apk"
        }
    }


    signingConfigs {
        if (hasKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storePassword = keystoreProperties["storePassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            }
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            ndk.debugSymbolLevel = "FULL"
            signingConfig = signingConfigs.findByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
        }
        getByName("debug") {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            ndk.debugSymbolLevel = "SYMBOL_TABLE"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("androidx.multidex:multidex:2.0.1")

    // firebase
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
}

