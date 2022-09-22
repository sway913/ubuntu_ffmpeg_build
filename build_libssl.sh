#! /bin/bash
# openssl，ffmpeg通过编译参数--enable-openssl --enable-protocols --enable-protocol=https来开启

set -e

OPENSSL="openssl"
OPENSSL_VERSION="1.1.1p"
OPENSSL_URL="https://www.openssl.org/source/old/1.1.1/"
OPENSSL_CONFIGURE_COMMAND="./config
--prefix=$PREFIX
"

if [[ "$enableShared" == true  ]]; then
 OPENSSL_CONFIGURE_COMMAND=$OPENSSL_CONFIGURE_COMMAND"
 -fPIC no-dso no-ssl3
 "
else
 OPENSSL_CONFIGURE_COMMAND=$OPENSSL_CONFIGURE_COMMAND"
 -fPIC no-shared no-dso no-ssl3
 "
fi

echo "==========================download openssl=========================="
if [ ! -e $OPENSSL"-"$OPENSSL_VERSION".tar.gz" ]; then
 if [[ $SYSTEM == "Darwin" ]]; then
  curl $OPENSSL_URL$OPENSSL"-"$OPENSSL_VERSION".tar.gz" > $OPENSSL"-"$OPENSSL_VERSION".tar.gz"
 else
  wget $OPENSSL_URL$OPENSSL"-"$OPENSSL_VERSION".tar.gz" -O $OPENSSL"-"$OPENSSL_VERSION".tar.gz"
 fi
fi
 
echo "==========================unzip openssl=========================="
if [ -e $OPENSSL"-"$OPENSSL_VERSION".tar.gz" ]; then
 if [ -e $OPENSSL"-"$OPENSSL_VERSION ]; then
  rm -rf $OPENSSL"-"$OPENSSL_VERSION
 fi
 tar zxvf $OPENSSL"-"$OPENSSL_VERSION".tar.gz"
fi

echo "==========================build openssl=========================="
if [ -e $OPENSSL"-"$OPENSSL_VERSION ]; then
 cd $OPENSSL"-"$OPENSSL_VERSION
 $OPENSSL_CONFIGURE_COMMAND
 make clean
 make -j${cpu_num}
 make install
fi
cd $MY_DIR
echo "==========================OPENSSL build successful!=========================="
