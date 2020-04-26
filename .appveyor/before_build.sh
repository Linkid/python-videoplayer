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
    rpm --Uvh http://www.nosuchhost.net/~cheese/fedora/packages/epel-6/$basearch/cheese-release-6-1.noarch.rpm
    yum -y install libswscale-devel

elif [[ $APPVEYOR_BUILD_WORKER_IMAGE == "macos-mojave" ]]
then
    # macos
    echo "osx"
    #brew update
    #brew cask install xquartz
    #brew install glib freeglut libogg theora ffmpeg
fi
uname -a
uname
