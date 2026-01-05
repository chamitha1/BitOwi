import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

/* 🔐 Load keystore properties */
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.bitowi.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.bitowi.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters.clear()
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    /* 🔐 Signing Config */
    /*signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }*/
    signingConfigs {
        create("release") {
            //Try to read values safely using 'as? String'
            val kAlias = keystoreProperties["keyAlias"] as? String
            val kPassword = keystoreProperties["keyPassword"] as? String
            val sFile = keystoreProperties["storeFile"] as? String
            val sPassword = keystoreProperties["storePassword"] as? String

            // Only configure signing if all values are present
            if (kAlias != null && kPassword != null && sFile != null && sPassword != null) {
                keyAlias = kAlias
                keyPassword = kPassword
                storeFile = file(sFile)
                storePassword = sPassword
            } else {
                //  Print a warning to the console
                println(" Release signing config not found. Release builds may fail.")
            }
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }

        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    packaging {
        jniLibs {
            excludes += setOf(
                //"**/x86_64/**",
                "**/libbarhopper_v3.so",
                "**/libimage_processing_util_jni.so"
            )
        }
    }
}

flutter {
    source = "../.."
}
