@echo off
SETLOCAL

REM === CONFIG BEGIN =============================================

REM The Bundletool location
SET BUNDLETOOL=%HOMEDRIVE%%HOMEPATH%\AppData\Local\Android\Sdk\bundletool-all-1.5.0.jar

REM === CONFIG END ===============================================

PUSHD "%~dp0"
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

REM Build APKs
del /q bin\hello.apks
"%JDK%\bin\java" -jar "%BUNDLETOOL%" build-apks --bundle=bin\hello.aab --output=bin\hello.apks --ks=src\demo.keystore --ks-key-alias=demo --ks-pass=pass:password
IF %ERRORLEVEL% NEQ 0 GOTO EXIT

REM Uninstall previous version of the app, if any
adb uninstall com.celer.hello

REM Install APK
"%JDK%\bin\java" -jar "%BUNDLETOOL%" install-apks --apks=bin\hello.apks
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
