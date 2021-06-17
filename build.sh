#!/bin/bash

# https://gist.github.com/tpmccallum/0d5974bfbae03f6cd0b4a107c4f454f8
# https://github.com/narxar/dingacoin.git
# git@github.com:narxar/dingacoin.git
# 

CRYPTO_ROOT="/home/narxar/crypto"
DINGACOIN_ROOT="${CRYPTO_ROOT}/dingacoin"
BDB_PREFIX="${CRYPTO_ROOT}/tools/db5"
mkdir -p $BDB_PREFIX

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y

sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y

#sudo apt-get install libdb5.1-dev libdb5.1++-dev -y
sudo apt-get install libdb-dev libdb++-dev -y 

cd ${CRYPTO_ROOT}/tools
wget http://download.oracle.com/berkeley-db/db-5.1.29.NC.tar.gz 

tar -xvf db-5.1.29.NC.tar.gz

sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-5.1.29.NC/src/dbinc/atomic.h

cd db-5.1.29.NC/build_unix/

../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BDB_PREFIX}

make install

cd ${DINGACOIN_ROOT}
./autogen.sh

# CFLAGS="-O2 -fPIC -DUSE_SSE2" CPPFLAGS="-O2 -fPIC -DUSE_SSE2"
# ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"

CFLAGS="-O2 -fPIC -DUSE_SSE2" CPPFLAGS="-O2 -fPIC -DUSE_SSE2" ./configure --disable-tests LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"

