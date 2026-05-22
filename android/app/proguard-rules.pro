# ML Kit Text Recognition - suppress missing class warnings for non-Latin languages
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-keep class com.google.mlkit.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep custom model classes
-keep class com.example.psold.** { *; }

# Flutter specific
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Gson / JSON
-keepattributes Signature
-keepattributes *Annotation*
-keep class * extends java.util.List
-keep class * extends java.util.Map

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
