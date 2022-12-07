#! /bin/bash

# mac --cc=clang
# 禁用编译器优化选项 --disable-optimizations
# 编译libmp3lame需要使用到--extra-cflags和--extra-ldflags属性

set -e

PATH=$PATH:$PREFIX/lib # 设置环境变量，将$PREFIX/bin目录下的可执行二进制文件设置进去，方便调用
#ffmpeg install path
export PREFIX_FF=$PREFIX/ffmpeg

PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

FFMPEG="FFmpeg"

ADDI_CFLAGS=" "
ADDI_LDFLAGS=" "

# 通用配置
COMMON_FFMPEG_CONFIGURE_COMMAND="./configure
--prefix=$PREFIX_FF
--pkg-config-flags="--static"
--extra-libs="-lpthread"
--disable-doc
--disable-sdl2
--disable-avdevice
--enable-ffplay
--enable-gpl
--enable-version3
--disable-optimizations
--disable-debug
--enable-pic
--enable-nonfree
--enable-filter=delogo
"

if [[ "$enableSharedFFmpeg" == true  ]]; then
 COMMON_FFMPEG_CONFIGURE_COMMAND=$COMMON_FFMPEG_CONFIGURE_COMMAND"
 --enable-shared
 --disable-static
 "
else
 COMMON_FFMPEG_CONFIGURE_COMMAND=$COMMON_FFMPEG_CONFIGURE_COMMAND"
 --enable-static
 --disable-shared
 "
fi

 COMMON_FFMPEG_CONFIGURE_COMMAND=$COMMON_FFMPEG_CONFIGURE_COMMAND"
 --extra-cflags=-I$PREFIX/include  $ADDI_CFLAGS
 --extra-ldflags=-L$PREFIX/lib  $ADDI_LDFLAGS
 "

# linux配置
LINUX_FFMPEG_CONFIGURE_COMMAND=$COMMON_FFMPEG_CONFIGURE_COMMAND"
--enable-libx264
--enable-libx265
--enable-libfdk-aac
--enable-libmp3lame
--enable-libopus
--enable-libvpx
--enable-openssl
"

# mac配置
MAC_CONFIGURE_COMMAND=$COMMON_FFMPEG_CONFIGURE_COMMAND"
--enable-libfdk-aac
--enable-libx264
--enable-libmp3lame
--enable-hardcoded-tables
--host-cflags=
--host-ldflags=
--cc=clang
"

FFMPEG_GIT_URL="https://github.com/FFmpeg/FFmpeg.git"


if [ ! -e $FFMPEG ]; then
 echo "==========================clone FFmpeg=========================="
 $CLONE_GIT_COMMAND$FFMPEG_GIT_URL
fi


echo "==========================build ffmpeg=========================="
if [ -e $FFMPEG ]; then
 cd $FFMPEG
 if [[ $SYSTEM == "Darwin" ]]; then
  $MAC_FFMPEG_CONFIGURE_COMMAND
 else
  $LINUX_FFMPEG_CONFIGURE_COMMAND
 fi
 make clean
 make -j${cpu_num}
 make install
fi


echo "==========================ffmpeg build successful!=========================="
