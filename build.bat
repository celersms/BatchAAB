@echo off
SETLOCAL

REM === CONFIGURATION BEGIN =============================================

REM The Android SDK Build Tools location
SET BUILD_TOOLS=%HOMEDRIVE%%HOMEPATH%\AppData\Local\Android\Sdk\build-tools\29.0.2

REM The location of android.jar for the current API level
SET ANDROID_JAR=%HOMEDRIVE%%HOMEPATH%\AppData\Local\Android\Sdk\platforms\android-29\android.jar

REM The Bundletool location
SET BUNDLETOOL=%HOMEDRIVE%%HOMEPATH%\AppData\Local\Android\Sdk\bundletool-all-1.5.0.jar

REM === CONFIGURATION END ===============================================

TITLE Building the Hello World AAB...
PUSHD "%~dp0"
SET PROJ=%~dp0

REM Get JDK path
SET JMINVER=1.6
SET JDK=%JDK_HOME%
IF EXIST "%JDK%\bin\javac.exe" GOTO JDKFOUND
SET JDK=%JAVA_HOME%
IF EXIST "%JDK%\bin\javac.exe" GOTO JDKFOUND
FOR /f "tokens=2*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit" /s 2^>nul ^| find "JavaHome"') DO SET JDK=%%j
IF EXIST "%JDK%\bin\javac.exe" GOTO JDKFOUND
FOR /f "tokens=2*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Development Kit" /s 2^>nul ^| find "JavaHome"') DO SET JDK=%%j
IF NOT EXIST "%JDK%\bin\javac.exe" GOTO JDKNOTFOUND
:JDKFOUND
IF NOT EXIST "%BUNDLETOOL%" GOTO NOBUNDLETOOL

REM Cleanup
rd /s /q bin obj >nul 2>nul
mkdir bin obj 2>nul
cd "%BUILD_TOOLS%"

REM Compile the resources
aapt2 compile --dir %PROJ%\res\ -o "%PROJ%\obj\res.zip"
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Link the resources
aapt2 link --proto-format -o "%PROJ%\obj\linked.zip" -I "%ANDROID_JAR%" --manifest "%PROJ%\src\AndroidManifest.xml" --java "%PROJ%\src" "%PROJ%\obj\res.zip" --auto-add-overlay
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Compile Java to bytecode
cd "%PROJ%"
"%JDK%\bin\javac" -source %JMINVER% -target %JMINVER% -d obj -classpath src;"%JDK%\jre\lib\jsse.jar" -bootclasspath "%ANDROID_JAR%" src\com\celer\hello\Main.java
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Convert the bytecode to Dex (Dalvik)
cd "%BUILD_TOOLS%"
call dx --dex --output="%PROJ%\bin\classes.dex" "%PROJ%\obj"
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Prepare base bundle
cd "%PROJ%\obj"
"%JDK%\bin\jar" xf linked.zip resources.pb AndroidManifest.xml res
mkdir manifest dex 2>nul
move AndroidManifest.xml manifest
copy /Y /B ..\bin\classes*.dex dex\ 2>nul
"%JDK%\bin\jar" cMf base.zip manifest dex res resources.pb
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Build the AAB
"%JDK%\bin\java" -jar "%BUNDLETOOL%" build-bundle --modules=base.zip --output=..\bin\hello.aab
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Sign the AAB
"%JDK%\bin\jarsigner" -keystore "%PROJ%\src\demo.keystore" -storepass password ..\bin\hello.aab demo
GOTO EXIT

:JDKNOTFOUND
ECHO JDK not found. If you have JDK %JMINVER% or later installed set JDK_HOME to point to the JDK location.
GOTO EXIT

:NOBUNDLETOOL
ECHO Bundletool not found at %BUNDLETOOL%
ECHO Download the latest version from https://github.com/google/bundletool/releases
ECHO Set the BUNDLETOOL configuration parameter to the Bundletool jarfile location.

:EXIT
pause
POPD
ENDLOCAL
@echo on
