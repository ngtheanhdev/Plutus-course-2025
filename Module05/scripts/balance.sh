#!/bin/bash

source util.sh

if [ -z "$1" ]; then
    >&2 echo "Expected address name as argument"
    return
fi

ADDRESS=$(cat $ASSETS_DIR/$1.addr)
cardano-cli query utxo --$NETWORK --address $ADDRESS --output-text
