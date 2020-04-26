# before build on Windows

# set the arch
$env:platform = $env:PROCESSOR_ARCHITECTURE

# set the arch for VS 2015
# https://www.appveyor.com/docs/lang/cpp/
# https://help.appveyor.com/discussions/questions/18777-how-to-use-vcvars64bat-from-powershell#comment_44999171
# if ($env:APPVEYOR_BUILD_WORKER_IMAGE -eq "Visual Studio 2015") {
if ($env:platform -eq "x64") {
    cmd.exe /c "call `"C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd`" /x64 && call `"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat`" x86_amd64 && set > %temp%\vcvars.txt"
} else {
    cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat`" x86 && set > %temp%\vcvars.txt"
}

# set varsall vars
Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
  if ($_ -match "^(.*?)=(.*)$") {
    Set-Content "env:\$($matches[1])" $matches[2]
  }
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
$VCPKG_BUILD=1
$VCPKG_TOOLCHAIN="C:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
Set-Content "env:VCPKG_BUILD" $VCPKG_BUILD
Set-Content "env:VCPKG_TOOLCHAIN" $VCPKG_TOOLCHAIN
#echo "${env:PATH}"
#ls env:
