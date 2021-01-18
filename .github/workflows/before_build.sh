#!/bin/bash
# before build

#set -e

# get the operating system
operating_system=$(echo "$1" | tr '[:upper:]' '[:lower:]')

#
# functions
#
compile_ffmpeg () {
    # https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
    # enable only libswscale
    yum -y -q install autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel
    curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar xjf ffmpeg-snapshot.tar.bz2
    cd ffmpeg
    ./configure \
      --disable-static \
      --enable-shared \
      --disable-ffmpeg \
      --disable-ffplay \
      --disable-ffprobe \
      --disable-avdevice \
      --disable-avcodec \
      --disable-avformat \
      --disable-avfilter \
      --disable-postproc \
      --disable-swresample \
      --disable-x86asm \
      --disable-doc
    make
    make install
    hash -d ffmpeg
}

#
# install system dependencies
#
echo "[+] Operating system: " ${operating_system}
case ${operating_system} in

    "ubuntu"*)
        # linux (centos 5): manylinux1, glib 2.12.3, ogg 1.1.3, theora 1.0a7 (no theoradec)
        # linux (centos 6): manylinux2010, glib 2.28.8, ogg 1.1.4, theora 1.1.0, ffmpeg 2.6.3
        # linux (centos 7): manylinux2014, glib 2.56.1, ogg 1.3.0, theora 1.1.1, ffmpeg 2.6.2
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
        echo "[*] Install ffmpeg"
        if [[ $( grep "release 6" /etc/redhat-release ) ]]
        then
            echo "[*] via Cheese (RPM for centos6)"
            rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
            yum -y install libswscale-devel
        elif [[ $( grep "release 7" /etc/redhat-release ) && `arch` == 'x86_64' ]]
        then
            echo "[*] via Cheese (RPM for centos7 (x64)"
            rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-7/$basearch/cheese-release-7-1.noarch.rpm
            yum -y install libswscale-devel
        #elif [[ $( grep "release 8" /etc/redhat-release ) && (`arch` == 'x86_64' || `arch` == 'aarch64') ]]
        #then
        #    echo "[*] via RPM Fusion (RPM for centos8)"
        #    dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
        #    dnf install ffmpeg-devel
        else
            echo "[*] compile ffmpeg"
            compile_ffmpeg
        fi
    ;;

    "macos"*)
        # macos
        echo "[*] osx"
        brew update --quiet > /dev/null
        brew install --quiet \
            glib \
            libogg \
            theora \
            ffmpeg
    ;;

    "windows"*)
        # windows
        echo "[*] windows"

        if [[ $( echo ${CIBW_BUILD} | grep win32 ) ]]
        then
            export VCPKG_DEFAULT_TRIPLET=x86-windows
        else
            export VCPKG_DEFAULT_TRIPLET=x64-windows
        fi

        vcpkg install glib \
                      libogg \
                      libtheora \
                      ffmpeg \
                      msinttypes
        echo "[*] integrate"
        vcpkg integrate install
        #echo "[*] list"
        #vcpkg list
    ;;

    "mingw"*)
        mkdir -p win_dep
        cd win_dep
        wget "http://repo.msys2.org/mingw/${MINGW_ARCH}/mingw-w64-${MINGW_ARCH}-glib2-2.64.2-1-any.pkg.tar.xz" -OutFile glib2.tar.xz
        wget "http://repo.msys2.org/mingw/${MINGW_ARCH}/mingw-w64-${MINGW_ARCH}-libogg-1.3.4-3-any.pkg.tar.xz" -OutFile libogg.tar.xz
        wget "http://repo.msys2.org/mingw/${MINGW_ARCH}/mingw-w64-${MINGW_ARCH}-libtheora-1.1.1-4-any.pkg.tar.xz" -OutFile libtheora.tar.xz
        wget "http://repo.msys2.org/mingw/${MINGW_ARCH}/mingw-w64-${MINGW_ARCH}-ffmpeg-4.2.2-4-any.pkg.tar.xz" -OutFile ffmpeg.tar.xz

        7z x glib2.tar.xz
        7z x libogg.tar.xz
        7z x libtheora.tar.xz
        7z x ffmpeg.tar.xz

        tar xf glib2.tar
        tar xf libogg.tar
        tar xf libtheora.tar
        tar xf ffmpeg.tar

        libs=`find ${MINGW_DIR} -name "lib*.dll.a"`
        for f in $libs
        do
            mv -- "$f" "${f%.dll.a}.lib"
        done
        #find ${MINGW_DIR} -name "lib*.dll.a" -exec sh -c 'f={}; mv -- "$f" "${f%.dll.a}.lib"' \;
        mv ${MINGW_DIR}/* .

        mkdir -p include/msinttypes
        wget https://raw.githubusercontent.com/chemeris/msinttypes/master/stdint.h -OutFile include\msinttypes\stdint.h
        wget https://raw.githubusercontent.com/chemeris/msinttypes/master/inttypes.h -OutFile include\msinttypes\inttypes.h
        cd ..
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
