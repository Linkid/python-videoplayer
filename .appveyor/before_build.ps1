# before build on Windows

# PATH: add dumpbin
# https://www.appveyor.com/docs/lang/cpp/
$env:Path += "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"
$env:VCPKG_BUILD = 1
where dumpbin
echo "${env:PATH}"

# set the arch
if ($env:platform -eq "x64") {
    set varsall="amd64"  # x86_amd64
} else {
    set varsall="x86"
}
& "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /${env:platform}
& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" $env:varsall

# vcpkg: install dependencies
echo "${env:platform}-windows"
ls env:
vcpkg install glib:"${env:platform}"-windows {
              libogg:"${env:platform}"-windows
              libtheora:"${env:platform}"-windows
              ffmpeg:"${env:platform}"-windows
}
#vcpkg export  glib:${env:platform}-windows
#              libogg:${env:platform}-windows
#              libtheora:${env:platform}-windows
#              ffmpeg:${env:platform}-windows --zip
#cp c:\Tools\vcpkg\"vcpkg-export-*.zip" $env:APPVEYOR_BUILD_FOLDER --output=vcpkg-export.zip

# vcpkg: integrate
cd c:\tools\vcpkg
vcpkg integrate install
vcpkg list --triplet "${env:platform}"-windows
cd $env:APPVEYOR_BUILD_FOLDER
