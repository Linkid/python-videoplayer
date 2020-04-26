# before build

if [[ `uname` == "Linux" ]]
then
    # linux (centos 6)
    echo "yyyy `cat /etc/redhat-release` (`arch`)"
    if [[ `arch` == 'x86_64' ]]
    then
        basearch=i386
    else
        basearch=i686
    fi
    yum -y install glib2-devel freeglut-devel libogg-devel libtheora-devel
    rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
    yum -y install libswscale-devel

elif [[ $APPVEYOR_BUILD_WORKER_IMAGE == "macos-mojave" ]]
then
    # macos
    echo "osx"
    #brew update
    #brew cask install xquartz
    #brew install glib freeglut libogg theora ffmpeg
    brew install ffmpeg

elif [[ $APPVEYOR_BUILD_WORKER_IMAGE == "Visual Studio 2015" ]]
then
    # windows
    echo "windows"
    platform=$PROCESSOR_ARCHITECTURE
    if [[ $platform == "x64" ]]
    then
        ./"C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64
        ./"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
    else
        ./"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
    fi

    vcpkg install glib:${platform}-windows \
                  libogg:${platform}-windows \
                  libtheora:${platform}-windows \
                  ffmpeg:${platform}-windows
    cd c:\tools\vcpkg
    vcpkg integrate install
    vcpkg list --triplet '"${platform}"-windows'
    cd $APPVEYOR_BUILD_FOLDER

    export VCPKG_BUILD=1
    export VCPKG_TOOLCHAIN="C:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
fi
uname -a
uname
