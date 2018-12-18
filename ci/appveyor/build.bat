@echo on
@rem Matrix-driven Appveyor CI build script
@rem Currently only supports MSYS2 builds.
@rem See https://www.appveyor.com/docs/installed-software#mingw-msys-cygwin
@rem Required vars:
@rem    BUILD_STEP
@rem    MSYS2_ROOT

SETLOCAL ENABLEEXTENSIONS
cd %APPVEYOR_BUILD_FOLDER%

@echo Current time: %time%
rem Set the paths appropriately

call "C:\Program Files (x86)\Microsoft Visual Studio %VS_VERSION%\VC\vcvarsall.bat" %PLATFORM%
@echo on
SET PATH=%MSYS2_ROOT%\mingw64\bin;%MSYS2_ROOT%\usr\bin;%PATH%

@echo Current time: %time%
rem Maybe use cached build artifacts
IF NOT EXIST "_build\default_%ERTS_VERSION%" GOTO BUILDSTART
robocopy "_build\default_%ERTS_VERSION%" "_build\default" /MIR /COPYALL /NP /NS /NC /NFL /NDL

:BUILDSTART
GOTO BUILD_%BUILD_STEP%

:BUILD_build
@echo Current time: %time%
rem Run build: build
bash -lc "cd %BUILD_PATH% && make KIND=test local-build"

GOTO BUILD_DONE

:BUILD_
:BUILD_DONE

@echo Current time: %time%
rem Mirror build artifacts
robocopy "_build\default" "_build\default_%ERTS_VERSION%" /MIR /COPYALL /NP /NS /NC /NFL /NDL

@echo Current time: %time%
rem Finished build phase
