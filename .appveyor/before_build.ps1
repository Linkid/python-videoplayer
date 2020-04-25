# before build on Windows

# PATH: add dumpbin
# https://www.appveyor.com/docs/lang/cpp/
$env:Path += ";C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"
$env:VCPKG_BUILD = 1
echo "${env:PATH}"

# set the arch
if ($env:platform -eq "x64") {
    #$varsall="amd64"  # "x86_amd64"
    $varsall="x86_amd64"
} else {
    New-Variable -Name "varsall" -Value "x86"
    $varsall="x86"
}
echo $varsall
& "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /${env:platform}
& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" $varsall

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
#cp c:\Tools\vcpkg\"vcpkg-export-*.zip" --output=vcpkg-export.zip $env:APPVEYOR_BUILD_FOLDER

# vcpkg: integrate
cd c:\tools\vcpkg
vcpkg integrate install
vcpkg list --triplet '"${env:platform}"-windows'
cd $env:APPVEYOR_BUILD_FOLDER

# set var
$env:VCPKG_TOOLCHAIN="C:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
