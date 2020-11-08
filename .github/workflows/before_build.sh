#!/bin/bash
# before build

set -e

# get the operating system
operating_system=$1

#
# install system dependencies
#
echo ${operating_system}
case $operating_system in

    "ubuntu*")
        # linux (centos 6)
        # arch
        echo "`cat /etc/redhat-release` (`arch`)"
        if [[ `arch` == 'i686' ]]
        then
            basearch=i386
        else
            basearch=x86_64
        fi

        # install
        yum -y install \
            glib2-devel \
            freeglut-devel \
            libogg-devel \
            libtheora-devel
        rpm -Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
        yum -y install libswscale-devel
    ;;

    "macos")
        # macos
        echo "osx"
        brew update
        brew install \
            glib \
            libogg \
            theora \
            ffmpeg
    ;;

    "windows*")
        # windows
        echo "windows"
    ;;

    *)
        echo ${operating_system}
    ;;
esac

#
# install python dependencies
#
pip install cython scikit-build cmake ninja
