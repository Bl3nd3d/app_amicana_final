// android/settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "android"
include(":app")

// Esta es una forma moderna y correcta de cargar los plugins de Flutter
// que tu versión de Flutter y Gradle esperan.
apply(from = File(settings.rootDir.parentFile, ".flutter-plugins"))