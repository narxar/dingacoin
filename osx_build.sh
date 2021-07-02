#!/bin/bash

xcode-select --install

CRYPTO_ROOT="/Users/yaungmin/Workspace/Coins/crypto"
DINGACOIN_ROOT="${CRYPTO_ROOT}/dingacoin"
BDB_PREFIX="${CRYPTO_ROOT}/tools/db5"
mkdir -p $BDB_PREFIX

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install automake libtool boost miniupnpc openssl pkg-config protobuf qt5 libevent

# brew install berkeley-db # You need to make sure you install a version >= 5.1.29, but as close to 5.1.29 as possible. Check the homebrew docs to find out how to install older versions.



brew install librsvg

brew install wget openssl

cd ${CRYPTO_ROOT}/tools
wget http://download.oracle.com/berkeley-db/db-5.1.29.NC.tar.gz

tar -xvf db-5.1.29.NC.tar.gz

# Run the following command manually
# sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-5.1.29.NC/src/dbinc/atomic.h
# vi db-5.1.29.NC/src/dbinc/atomic.h 
# 1,$s@__atomic_compare_exchange@__atomic_compare_exchange_db@g
# 1,$s@atomic_init@atomic_init_db@g
# vi db-5.1.29.NC/src/mp/mp_fget.c
# 1,$s@atomic_init@atomic_init_db@g
# vi db-5.1.29.NC/src/mp/mp_mvcc.c
# 1,$s@atomic_init@atomic_init_db@g
# vi db-5.1.29.NC/src/mp/mp_region.c
# 1,$s@atomic_init@atomic_init_db@g
# vi db-5.1.29.NC/src/mutex/mut_method.c
# 1,$s@atomic_init@atomic_init_db@g
# vi db-5.1.29.NC/src/mutex/mut_tas.c
# 1,$s@atomic_init@atomic_init_db@g



cd db-5.1.29.NC/build_unix/

# ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BDB_PREFIX}
../dist/configure LDFLAGS='-arch x86_64' CFLAGS='-arch x86_64' --enable-cxx --disable-shared --with-pic --prefix=${BDB_PREFIX}

make install

cd ${DINGACOIN_ROOT}
./autogen.sh

CFLAGS="-O2 -fPIC -DUSE_SSE2" CPPFLAGS="-O2 -fPIC -DUSE_SSE2" ./configure --disable-tests LDFLAGS="-L${BDB_PREFIX}/lib/ -L/usr/local/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/ -I/usr/local/Cellar/openssl@1.1/1.1.1k/include/"

# ./configure

make

