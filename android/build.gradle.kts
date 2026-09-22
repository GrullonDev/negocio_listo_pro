allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Legacy plugins (e.g. isar_flutter_libs 3.1.0+1) predate AGP's mandatory
// `namespace` requirement and don't declare one in their own build.gradle.
// Patch it in from the manifest package so AGP can configure the module.
// withPlugin's callback fires as soon as the plugin is applied, before
// evaluation completes, so it works even though evaluationDependsOn(":app")
// above forces early evaluation of these subprojects.
// Plugins like connectivity_plus also pin their own compileSdkVersion,
// independent of the app module's `compileSdk = 36`. Bump it here too so
// their AndroidX deps (which now require API 34+) resolve.
subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.getByName("android") as com.android.build.gradle.LibraryExtension
        if (android.namespace == null) {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val manifestText = manifestFile.readText()
                val packageMatch = Regex("package=\"([^\"]+)\"").find(manifestText)
                packageMatch?.groupValues?.get(1)?.let { android.namespace = it }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
