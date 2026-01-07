-keep class com.google.firebase.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepattributes *Annotation*
-keep class * {
    @pragma("vm:entry-point") *;
}