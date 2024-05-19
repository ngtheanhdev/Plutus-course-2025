#!/bin/bash

source util.sh

if [ -z "$1" ]; then
    >&2 echo "Expected wallet name as argument"
    exit 1
fi

NAME=$1
VKEY="$ASSETS_DIR/$NAME.vkey"
SKEY="$ASSETS_DIR/$NAME.skey"
ADDR="$ASSETS_DIR/$NAME.addr"

if [ -f "$VKEY" ] && [ -f "$SKEY" ]
then
    echo "Key pairs already exist: $VKEY, $SKEY"
else
    cardano-cli address key-gen --verification-key-file "$VKEY" --signing-key-file "$SKEY" &&
    echo "wrote verification key to: $VKEY"
    echo "wrote signing key to: $SKEY"
fi

if [ ! -f "$ADDR" ]; then
    cardano-cli address build --payment-verification-key-file "$VKEY" --$NETWORK --out-file "$ADDR"
    echo "wrote address to: $ADDR"
fi
