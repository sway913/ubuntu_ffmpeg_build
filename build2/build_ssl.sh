#! /bin/bash
# openssl，https protocol .ffmpeg通过编译参数--enable-openssl来开启

set -e

PATH=$PATH:$PREFIX/bin # 设置环境变量，将$PREFIX/bin目录下的可执行二进制文件设置进去，方便调用

LIBOPENSSL="openssl"
LIBOPENSSL_URL="https://www.openssl.org/source/old/1.1.1/openssl-1.1.1q.tar.gz"
LIBOPENSSL_VERSION="1.1.1q"
LIBOPENSSL_CONFIGURE_COMMAND="./config
--prefix=$PREFIX
--openssldir=${PREFIX}/openssl -fPIC 
"

if [[ "$enableShared" == true  ]]; then
 LIBOPENSSL_CONFIGURE_COMMAND=$LIBOPENSSL_CONFIGURE_COMMAND"

 "
else
 LIBOPENSSL_CONFIGURE_COMMAND=$LIBOPENSSL_CONFIGURE_COMMAND"
 no-shared 
 "
fi

echo "==========================download libopenssl=========================="
if [ ! -e $LIBOPENSSL"-"$LIBOPENSSL_VERSION".tar.gz" ]; then
 if [[ $SYSTEM == "Darwin" ]]; then
  curl $LIBOPENSSL_URL > $LIBOPENSSL"-"$LIBOPENSSL_VERSION".tar.gz"
 else
  wget $LIBOPENSSL_URL  -O $LIBOPENSSL"-"$LIBOPENSSL_VERSION".tar.gz"
 fi
fi
 
echo "==========================unzip libopenssl=========================="
if [ -e $LIBOPENSSL"-"$LIBOPENSSL_VERSION".tar.gz" ]; then
 if [ -e $LIBOPENSSL"-"$LIBOPENSSL_VERSION ]; then
  rm -rf $LIBOPENSSL"-"$LIBOPENSSL_VERSION
 fi
 tar zxvf $LIBOPENSSL"-"$LIBOPENSSL_VERSION".tar.gz"
fi

echo "==========================build libopenssl=========================="
if [ -e $LIBOPENSSL"-"$LIBOPENSSL_VERSION ]; then
 cd $LIBOPENSSL"-"$LIBOPENSSL_VERSION
 $LIBOPENSSL_CONFIGURE_COMMAND
 make clean
 make -j${cpu_num}
 make install
fi
cd $MY_DIR
echo "==========================libopenssl build successful!=========================="
