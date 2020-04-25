# before build on Windows

# set the arch for VS 2015
# https://www.appveyor.com/docs/lang/cpp/
if ($env:platform -eq "x64") {
    "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64
    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
} else {
    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
}

# vcpkg: install dependencies
vcpkg install glib:"${env:platform}"-windows
vcpkg install libogg:"${env:platform}"-windows
vcpkg install libtheora:"${env:platform}"-windows
vcpkg install ffmpeg:"${env:platform}"-windows
#vcpkg export  glib:${env:platform}-windows
#              libogg:${env:platform}-windows
#              libtheora:${env:platform}-windows
#              ffmpeg:${env:platform}-windows --zip
#cp c:\Tools\vcpkg\"vcpkg-export-*.zip" --output=vcpkg-export.zip $env:APPVEYOR_BUILD_FOLDER

# vcpkg: integrate
cd c:\tools\vcpkg
vcpkg integrate install
vcpkg list --triplet '"${env:platform}"-windows'
cd $env:APPVEYOR_BUILD_FOLDER

# set var
$env:VCPKG_BUILD = 1
$env:VCPKG_TOOLCHAIN="C:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
echo "${env:PATH}"
ls env:
