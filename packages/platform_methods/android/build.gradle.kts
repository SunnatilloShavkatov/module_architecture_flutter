plugins {
    id("com.android.library")
}

group = "uz.plugin.platform_methods"
version = "1.0-SNAPSHOT"

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.13.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

android {
    namespace = "uz.plugin.platform_methods"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")
    sourceSets["test"].java.srcDirs("src/test/kotlin")

    defaultConfig {
        minSdk = 26
    }

    android {
        testOptions {
            unitTests.all {
                it.useJUnitPlatform()
                it.testLogging.events("passed", "skipped", "failed", "standardOut", "standardError")
                it.testLogging.showStandardStreams = true
                it.outputs.upToDateWhen { false }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
    }
}

dependencies {
    implementation("com.google.android.play:review-ktx:2.0.2")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    testImplementation("org.mockito:mockito-core:5.20.0")
    testImplementation("org.jetbrains.kotlin:kotlin-test")
}
