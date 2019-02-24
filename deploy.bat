set projectPath=F:\Project\Magic2Snes\
set compilePath=F:\Project\compile\Magic2Snes\
set deployPath=F:\Project\deploy\Magic2Snes\
set originalBinDir=%compilePath%
set vscdll=F:\Visual Studio\VC\Redist\MSVC\14.12.25810\x64\Microsoft.VC141.CRT\msvcp140.dll

rmdir /Q /S %deployPath%
mkdir %deployPath%
:: Compile

::"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
mkdir %compilePath%
cd %compilePath%
cd

qmake %projectPath%\Magic2Snes.pro -spec win32-msvc "CONFIG+=release"
nmake

xcopy /y %originalBinDir%\release\Magic2Snes.exe %deployPath%


echo "Deploy QT"
windeployqt.exe --no-translations --no-opengl-sw --no-svg --no-webkit --no-webkit2 --release -qmldir %projectPath%\examples\ %deployPath%\Magic2Snes.exe

:: Clean up Qt extra stuff
::rmdir /Q /S %deployPath%\imageformats
::This shit is  24 Meg
::del %deployPath%\opengl32sw.dll 
::del %deployPath%\libEGL.dll
::del %deployPath%\libGLESV2.dll
del %deployPath%\vc_redist.x64.exe

::xcopy /y "%vscdll%" %deployPath%
rmdir /Q /S %deployPath%\examples
mkdir %deployPath%\examples
xcopy %projectPath%\examples %deployPath%\examples /syq
del %deployPath%\examples\*.qmlc.*
del %deployPath%\examples\smalttptracker\*.qmlc.*
del %deployPath%\examples\smalttptracker\*.jsc.*

cd %projectPath%