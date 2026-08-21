plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val ksStorePath = System.getenv("KEYSTORE_PATH")
val ksStorePassword = System.getenv("KEYSTORE_PASSWORD")
val ksKeyAlias = System.getenv("KEY_ALIAS")
val ksKeyPassword = System.getenv("KEY_PASSWORD")

val hasReleaseKeystore =
    !ksStorePath.isNullOrBlank() &&
    !ksStorePassword.isNullOrBlank() &&
    !ksKeyAlias.isNullOrBlank() &&
    !ksKeyPassword.isNullOrBlank()

android {
    namespace = "dev.edbn.roleta"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.edbn.roleta"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(ksStorePath)
                storePassword = ksStorePassword
                keyAlias = ksKeyAlias
                keyPassword = ksKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Signs with the debug key when the keystore env vars are not set,
                // so `flutter run --release` keeps working.
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
