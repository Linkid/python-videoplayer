#!/bin/bash
# before build

#set -e

# get the operating system
operating_system=$1

#
# install system dependencies
#
echo "[+] Operating system: " ${operating_system}
case ${operating_system} in

    "ubuntu"*)
        # linux (centos 6): manylinux2010
        # linux (centos 7): manylinux2014
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
        rpm -Uvh
        http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
        #rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-7/$basearch/cheese-release-7-1.noarch.rpm
        yum -y install libswscale-devel
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
