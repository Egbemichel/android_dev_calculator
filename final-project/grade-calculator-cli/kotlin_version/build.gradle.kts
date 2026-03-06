plugins {
    kotlin("jvm") version "1.9.22"
    application
}

group = "com.gradecalculator"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    // Apache POI for Excel handling
    implementation("org.apache.poi:poi:5.2.5")
    implementation("org.apache.poi:poi-ooxml:5.2.5")

    // Kotlin standard library
    implementation(kotlin("stdlib"))

    // Testing
    testImplementation(kotlin("test"))
}

application {
    mainClass.set("MainKt")
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(17)
}

tasks.named<JavaExec>("run") {
    standardInput = System.`in`
}

