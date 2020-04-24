# before build on Windows

# PATH: add dumpbin
# https://www.appveyor.com/docs/lang/cpp/
set PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin

# set the arch
If (%platform% -eq "x64") {
    set varsall="amd64"  # x86_amd64
} Else {
    set varsall="x68"
}
#call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /%platform%
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" %varsall%

# vcpkg: install dependencies
vcpkg install glib:%platform%-windows
              libogg:%platform%-windows
              libtheora:%platform%-windows
              ffmpeg:%platform%-windows
#vcpkg export  glib:%platform%-windows
#              libogg:%platform%-windows
#              libtheora:%platform%-windows
#              ffmpeg:%platform%-windows --zip
#cp c:\Tools\vcpkg\"vcpkg-export-*.zip" %APPVEYOR_BUILD_FOLDER%

# vcpkg: integrate
cd c:\tools\vcpkg
vcpkg integrate install
vcpkg list --triplet x64-windows
cd %APPVEYOR_BUILD_FOLDER%
