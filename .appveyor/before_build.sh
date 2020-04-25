# before build


if [ $APPVEYOR_BUILD_WORKER_IMAGE -eq "macos-mojave" ]
then
    # linux
    sudo apt-get -qq update
    sudo apt-get install -y freeglut3-dev libogg-dev libtheora-dev libswscale-dev

elif [ $APPVEYOR_BUILD_WORKER_IMAGE -eq "macos-mojave" ]
then
    # macos
    brew update
    brew install glib freeglut libogg theora ffmpeg
fi
