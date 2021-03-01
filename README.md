# A Hello World Android App Bundle (AAB) built from the command line, no IDE

This simple project shows how to build an Android App Bundle (AAB) using the
command line tools only, without any IDE.

In order to keep it as simple as possible we'll use only the JDK, the
Android SDK and the Bundletool. The latter can be downloaded from
https://github.com/google/bundletool/releases

Java 1.6 or later is required.

The Android SDK is no longer available as a standalone downloadable package
for Windows. It's necessary to download the Command Line Tools package from
https://developer.android.com/studio
The link to download the Command Line Tools is at the bottom of that page.

After that you can use the *sdkmanager* tool to download the Build Tools and
the platform files for the required Android API level. Currently the latest
API level is 29. You can also download AVD images to emulate an Android device.

The Android SDK Build Tools should be at least version 29.0.2. Previous
versions may not include the AAPT2 tool or there may be compatibility issues.

A sample keystore with a demo certificate is included. It's highly recommended
to generate your own certificate if you plan to modify and redistribute the
app. The JDK keytool can be used to generate a new certificate and store it
into a new keystore:
```
del src\demo.keystore /q
"%JAVA_HOME%"\bin\keytool -genkey -keystore src\demo.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias demo
```
Fill in all the details about yourself and your organization and select
an appropriate password. The password used in our sample keystore is
*password*

Edit **build.bat** using any text editor like Notepad and modify the
following configuration parameters:

- **BUILD_TOOLS** is the location of the Build Tools in the Android SDK. Version 29.0.2 or later is recommended.
- **ANDROID_JAR** is the path to the android.jar for the required Android API level.
- **BUNDLETOOL** is the location of the Bundletool jarfile. Try to use the latest version, if possible.

After that launch **build.bat** to create the AAB.
