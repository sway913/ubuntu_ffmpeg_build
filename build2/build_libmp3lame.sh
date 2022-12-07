#! /bin/bash
# 编码MP3音频，ffmpeg通过编译参数--enable-libmp3lame来开启

set -e

LAME="lame"
LAME_VERSION="3.100"
LAME_URL="https://sourceforge.net/projects/lame/files/lame/3.100/"
LAME_CONFIGURE_COMMAND="./configure
--prefix=$PREFIX
"

if [[ "$enableShared" == true  ]]; then
 LAME_CONFIGURE_COMMAND=$LAME_CONFIGURE_COMMAND"
 --enable-shared
 --disable-static
 "
else
 LAME_CONFIGURE_COMMAND=$LAME_CONFIGURE_COMMAND"
 --enable-static
 --disable-shared
 --with-pic 
 "
fi

echo "==========================download lame=========================="
if [ ! -e $LAME"-"$LAME_VERSION".tar.gz" ]; then
 if [[ $SYSTEM == "Darwin" ]]; then
  curl $LAME_URL$LAME"-"$LAME_VERSION".tar.gz" > $LAME"-"$LAME_VERSION".tar.gz"
 else
  wget $LAME_URL$LAME"-"$LAME_VERSION".tar.gz" -O $LAME"-"$LAME_VERSION".tar.gz"
 fi
fi
 
if [ ! -d "$LAME"-"$LAME_VERSION" ]; then
       echo "==========================unzip lame=========================="
       if [ -e $LAME"-"$LAME_VERSION".tar.gz" ]; then
       if [ -e $LAME"-"$LAME_VERSION ]; then
       rm -rf $LAME"-"$LAME_VERSION
       fi
       tar zxvf $LAME"-"$LAME_VERSION".tar.gz"
       fi
fi

echo "==========================build lame=========================="
if [ -e $LAME"-"$LAME_VERSION ]; then
 cd $LAME"-"$LAME_VERSION
 #rebuild
 if [[ "$reBuildDeps" == true  ]]; then
        $LAME_CONFIGURE_COMMAND
        make clean
        make -j${cpu_num}
        make install
 fi
fi
cd $MY_DIR
echo "==========================lame build successful!=========================="
