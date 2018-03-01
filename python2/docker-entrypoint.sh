#!/usr/bin/env sh

: ${HOSTNAME:=localhost}
: ${SSL_HOSTNAME:=$HOSTNAME}
: ${SSL_PREFIX:=/etc/letsencrypt/live/$SSL_HOSTNAME}

: ${JUPYTER_CERTFILE:=$SSL_PREFIX/fullchain.pem}
: ${JUPYTER_KEYFILE:=$SSL_PREFIX/privkey.pem}

set -e

if [ "$1" = 'notebook' ]
then
    shift

    exec jupyter notebook \
        --ip 0.0.0.0 \
        --no-browser \
        $@
fi

if [ "$1" = 'notebook-ssl' ]
then
    shift

    exec jupyter notebook \
        --certfile="${JUPYTER_CERTFILE}" \
        --keyfile="${JUPYTER_KEYFILE}" \
        --ip 0.0.0.0 \
        --no-browser \
        $@
fi

exec $@
