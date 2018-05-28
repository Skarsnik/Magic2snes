set projectPath=D:\Project\Magic2Snes\
set compilePath=D:\Project\compile\Magic2Snes\
set deployPath=D:\Project\deploy\Magic2Snes\
set originalBinDir=%compilePath%
set vscdll=D:\Visual Studio\VC\Redist\MSVC\14.12.25810\x64\Microsoft.VC141.CRT\msvcp140.dll

rmdir /Q /S %deployPath%
mkdir %deployPath%
:: Compile

::"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
mkdir %compilePath%
cd %compilePath%
cd
::set QMAKE_MSC_VER=1910
qmake %projectPath%\Magic2Snes.pro -spec win32-msvc "CONFIG+=release"
nmake

xcopy /y %originalBinDir%\release\Magic2Snes.exe %deployPath%


echo "Deploy QT"
windeployqt.exe --no-translations --no-system-d3d-compiler --no-opengl --no-svg --no-webkit --no-webkit2 --compiler-runtime --release -qmldir %projectPath%\examples\ %deployPath%\Magic2Snes.exe

:: Clean up Qt extra stuff
rmdir /Q /S %deployPath%\imageformats
::This shit is  24 Meg
del %deployPath%\opengl32sw.dll 
::del %deployPath%\libEGL.dll
::del %deployPath%\libGLESV2.dll

xcopy /y "%vscdll%" %deployPath%

cd %projectPath%