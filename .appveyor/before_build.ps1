# before build on Windows

# PATH: add dumpbin
# https://www.appveyor.com/docs/lang/cpp/
set PATH=$env:PATH;"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"
set VCPKG_BUILD=1

# set the arch
if ($env:platform -eq "x64") {
    set varsall="amd64"  # x86_amd64
} else {
    set varsall="x68"
}
#call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /%platform%
& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" $env:varsall

# vcpkg: install dependencies
echo "${env:platform}-windows"
ls env:
vcpkg install glib:"${env:platform}"-windows
vcpkg install libogg:"${env:platform}"-windows
vcpkg install libtheora:"${env:platform}"-windows
vcpkg install ffmpeg:"${env:platform}"-windows
#vcpkg export  glib:${env:platform}-windows
#              libogg:${env:platform}-windows
#              libtheora:${env:platform}-windows
#              ffmpeg:${env:platform}-windows --zip
#cp c:\Tools\vcpkg\"vcpkg-export-*.zip" $env:APPVEYOR_BUILD_FOLDER

# vcpkg: integrate
cd c:\tools\vcpkg
vcpkg integrate install
vcpkg list --triplet "${env:platform}"-windows
cd $env:APPVEYOR_BUILD_FOLDER
