#!/bin/bash
# before build

if [[ `uname` == "Linux" ]]
then
    # linux (centos 6)
    echo "`cat /etc/redhat-release` (`arch`)"
    if [[ `arch` == 'i686' ]]
    then
        basearch=i386
    else
        basearch=x86_64
    fi
    yum -y install glib2-devel freeglut-devel libogg-devel libtheora-devel
    rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
    yum -y install libswscale-devel

elif [[ $APPVEYOR_BUILD_WORKER_IMAGE == "macos-mojave" ]]
then
    # macos
    echo "osx"
    brew update
    #brew cask install xquartz
    #brew install glib freeglut libogg theora ffmpeg
    brew install glib ffmpeg

elif [[ $APPVEYOR_BUILD_WORKER_IMAGE == "Visual Studio 2015" ]]
then
    # windows
    echo "windows"
    echo $VCINSTALLDIR

    if [[ $PYTHON_ARCH == 32 ]]
    then
        platform=x86
        "${VS140COMNTOOLS}"/../../VC/vcvarsall.bat x86
    else
        platform=x64
        "${EXTENSIONSDKDIR}"/../../../Windows/v7.1/Bin/SetEnv.cmd /x64
        "${VS140COMNTOOLS}"/../../VC/vcvarsall.bat x86_amd64
    fi

    #vcpkg update
    #vcpkg list
    #vcpkg remove glib \
    #             libogg \
    #             libtheora \
    #             ffmpeg
    #vcpkg list

    export VCPKG_DEFAULT_TRIPLET=${platform}-windows
    vcpkg install glib \
                  libogg \
                  libtheora \
                  ffmpeg
    cd "c:/tools/vcpkg"
    vcpkg integrate install
    vcpkg list
    cd $APPVEYOR_BUILD_FOLDER

    pip install cython scikit-build cmake ninja
    python setup.py build_ext -i -f

    #export VCPKG_BUILD=1
    #export VCPKG_TOOLCHAIN="C:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
    printenv
fi
uname -a
uname
