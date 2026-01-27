# Flutter embedding
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Play services / MLKit (you use barcode scanning)
-dontwarn com.google.android.gms.**
-dontwarn com.google.mlkit.**
-keep class com.google.android.gms.** { *; }
-keep class com.google.mlkit.** { *; }

# Keep annotations/signatures (helps with reflection libs)
-keepattributes *Annotation*,Signature
