import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------------------------------------------------------------------------
// White-label: `--dart-define=BRAND=<clave>` decide nombre, applicationId y
// color del ícono. Flutter pasa las dart-defines a Gradle en la propiedad
// `dart-defines` (base64, separadas por comas). Tabla: branding/brands.conf.
// ---------------------------------------------------------------------------
data class NativeBrand(
    val key: String,
    val appName: String,
    val idSuffix: String,
    val launcherBackground: String,
)

val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.mapNotNull { encoded ->
            runCatching { String(Base64.getDecoder().decode(encoded), Charsets.UTF_8) }
                .getOrNull()
                ?.split("=", limit = 2)
                ?.takeIf { it.size == 2 }
                ?.let { it[0] to it[1] }
        }
        ?.toMap()
        ?: emptyMap()

val brandKey = dartDefines["BRAND"] ?: "default"

val brand: NativeBrand =
    rootProject.file("../branding/brands.conf")
        .readLines(Charsets.UTF_8)
        .map { it.trim() }
        .filter { it.isNotEmpty() && !it.startsWith("#") }
        .map { it.split("|") }
        .map { NativeBrand(it[0], it[1], it[2], it[3]) }
        .firstOrNull { it.key == brandKey }
        ?: throw GradleException(
            "Marca desconocida BRAND=$brandKey (ver branding/brands.conf)",
        )

android {
    namespace = "com.grullondev.negocio_listo_pro"
    // connectivity_plus's AndroidX deps (fragment 1.7.1, window 1.2.0, etc.)
    // require compileSdk 34+; flutter.compileSdkVersion still resolves to 33
    // on this Flutter version, so it's pinned here until the SDK catches up.
    // permission_handler_android 13 compiles against 37.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        // Necesario para los resValue de marca (app_name, color del ícono).
        resValues = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        // Cada marca es una app distinta (se instalan lado a lado).
        applicationId = "com.grullondev.negocio_listo_pro${brand.idSuffix}"
        resValue("string", "app_name", brand.appName)
        resValue("color", "brand_launcher_background", brand.launcherBackground)

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21
    }
}

flutter {
    source = "../.."
}
