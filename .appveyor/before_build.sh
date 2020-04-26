# before build

if [[ `uname` == "Linux" ]]
then
    # linux
    echo "xxx linux"
    yum -y install glib2-devel mesa-libGL-devel libogg-devel libtheora-devel libswscale-devel

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
