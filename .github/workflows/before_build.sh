#!/bin/bash
# before build

#set -e

# get the operating system
operating_system=$1

#
# functions
#
compile_ffmpeg () {
    # https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
    # enable only libswscale
    curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar xjvf ffmpeg-snapshot.tar.bz2
    cd ffmpeg
    ./configure
      --disable-static
      --enable-shared
      --enable-runtime-cpudetect
      --enable-memalign-hack
      --disable-everything
      --disable-ffmpeg
      --disable-ffplay
      --disable-ffserver
      --disable-ffprobe
      --disable-avdevice
      --disable-avcodec
      --disable-avformat
      --disable-avfilter
      --disable-swresample
      --disable-doc
    make
    make install
    #hash -d ffmpeg
}

#
# install system dependencies
#
echo "[+] Operating system: " ${operating_system}
case ${operating_system} in

    "ubuntu"*)
        # linux (centos 5): manylinux1, glib 2.12.3, ogg 1.1.3, theora 1.0a7
        # linux (centos 6): manylinux2010, glib 2.28.8, ogg 1.1.4, theora 1.1.0
        # linux (centos 7): manylinux2014, glib 2.56.1, ogg 1.3.0, theora 1.1.1
        cat /etc/redhat-release
        # arch
        echo "[*] `cat /etc/redhat-release` (`arch`)"
        if [[ `arch` == 'i686' ]]
        then
            basearch=i386
        else
            basearch=x86_64
        fi

        # install
        echo "[*] Install RPM packages"
        yum -y install \
            glib2-devel \
            freeglut-devel \
            libogg-devel \
            libtheora-devel

        # ffmpeg-libswscale
        if [[ $( grep "release 6" /etc/redhat-release ) ]]
        then
            echo "[*] Install RPM ffmpeg (centos6)"
            rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
            yum -y install libswscale-devel
        elif [[ $( grep "release 7" /etc/redhat-release ) ]] && [[ `arch` == 'x86_64' ]]
        then
            echo "[*] Install RPM ffmpeg (centos7, `arch`)"
            rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-7/$basearch/cheese-release-7-1.noarch.rpm
            yum -y install libswscale-devel
        else
            echo "[*] compile ffmpeg"
            compile_ffmpeg
        fi
    ;;

    "macos"*)
        # macos
        echo "[*] osx"
        brew update
        brew install \
            glib \
            libogg \
            theora \
            ffmpeg
    ;;

    "windows"*)
        # windows
        echo "[*] windows"

        export VCPKG_DEFAULT_TRIPLET=x64-windows
        vcpkg install glib \
                      libogg \
                      libtheora \
                      ffmpeg \
                      msiinttypes
        echo "[*] integrate"
        vcpkg integrate install
        echo "[*] list"
        vcpkg list
    ;;

    *)
        echo "[*] no OS: " ${operating_system}
    ;;
esac

#
# install python dependencies
#
echo "[+] Install python dependencies"
pip install cython scikit-build cmake ninja

echo "[+] All done"
