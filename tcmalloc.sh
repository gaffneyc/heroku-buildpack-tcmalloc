#!/bin/sh

export LD_PRELOAD="/app/vendor/tcmalloc/lib/libtcmalloc_minimal.so"
exec "$@"
