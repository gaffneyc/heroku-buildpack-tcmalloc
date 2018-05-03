#!/bin/bash
# usage: build [version] [stack]
set -e

version=$1
stack=$2
build=`mktemp -d`

tar -C $build --strip-components=1 -xz -f /wrk/src/gperftools-$version.tar.gz

cd $build
./configure --enable-minimal --disable-debugalloc --prefix=/app/vendor/tcmalloc/

# Build and install the libraries only
make install-libLTLIBRARIES

# Include the license with the bundle
cp COPYING /app/vendor/tcmalloc/

# Custom tcmalloc.sh for enabling tcmalloc on a per dyno basis
mkdir -p /app/vendor/tcmalloc/bin
cp /wrk/tcmalloc.sh /app/vendor/tcmalloc/bin
chmod 0555 /app/vendor/tcmalloc/bin/tcmalloc.sh

# Bundle and compress the compiled library
mkdir -p /wrk/dist/$stack
tar -C /app/vendor/tcmalloc -c . | bzip2 -9 > /wrk/dist/$stack/tcmalloc-$version.tar.bz2
