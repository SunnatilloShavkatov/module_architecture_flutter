plugins {
    id("com.android.library")
    kotlin("android")
}

group = "uz.nasiya.platform_methods"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion by extra("2.2.20")
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.13.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

android {
    namespace = "uz.nasiya.platform_methods"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
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

dependencies {
    testImplementation("org.mockito:mockito-core:5.20.0")
    testImplementation("org.jetbrains.kotlin:kotlin-test")
}