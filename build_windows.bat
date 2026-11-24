@echo off
setlocal

where cmake >nul 2>nul
if errorlevel 1 (
    echo CMake was not found on PATH.
    exit /b 1
)

where nmake >nul 2>nul
if errorlevel 1 (
    echo NMake was not found. Run this script from an x64 Visual Studio Developer Command Prompt.
    exit /b 1
)

where cl >nul 2>nul
if errorlevel 1 (
    echo MSVC was not found. Run this script from an x64 Visual Studio Developer Command Prompt.
    exit /b 1
)

pushd "%~dp0"
if errorlevel 1 exit /b 1

set "GC_DEPS_ROOT=%~1"
nmake /nologo /f Makefile.win all
set "BUILD_RESULT=%ERRORLEVEL%"

popd
exit /b %BUILD_RESULT%
