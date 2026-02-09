import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

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

        /* ndk {
            abiFilters.clear()
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        } */
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions { jvmTarget = "17" }

    signingConfigs {
        create("release") {
            val keyAliasVal = keystoreProperties["keyAlias"]?.toString()
            val keyPasswordVal = keystoreProperties["keyPassword"]?.toString()
            val storeFileVal = keystoreProperties["storeFile"]?.toString()
            val storePasswordVal = keystoreProperties["storePassword"]?.toString()

            if (!keyAliasVal.isNullOrBlank() &&
                !keyPasswordVal.isNullOrBlank() &&
                !storeFileVal.isNullOrBlank() &&
                !storePasswordVal.isNullOrBlank()
            ) {
                keyAlias = keyAliasVal
                keyPassword = keyPasswordVal
                storeFile = file(storeFileVal)
                storePassword = storePasswordVal
            }
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packaging {
        jniLibs {
            // Optional: if you don't support emulators
            excludes += setOf("**/x86/**")
        }
    }
}

configurations.configureEach {
    exclude(group = "com.google.mlkit", module = "barcode-scanning")
}

dependencies {
    implementation("com.google.android.gms:play-services-mlkit-barcode-scanning:18.3.1")
}

flutter {
    source = "../.."
}
