# before build

if [[ `uname` == "Linux" ]]
then
    # linux
    echo "xxx linux"
    sudo apt-get -qq update
    sudo apt-get install -y freeglut3-dev libogg-dev libtheora-dev libswscale-dev

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
