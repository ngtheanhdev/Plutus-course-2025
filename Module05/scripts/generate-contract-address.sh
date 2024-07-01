#!/bin/bash
source util.sh

if [ -z "$1" ]; then
    >&2 echo "Expected contract name as argument"
    exit 1
fi

SCRIPT_NAME=$(echo $1 | tr '[:upper:]' '[:lower:]')
SCRIPT_PATH=$ASSETS_DIR/$SCRIPT_NAME.plutus

if [ ! -f "$SCRIPT_PATH" ]; then
    >&2 echo "Plutus script $SCRIPT_PATH is not found."
    exit 1
fi

cardano-cli address build \
    --payment-script-file $SCRIPT_PATH \
    --$NETWORK \
    --out-file "$ASSETS_DIR/$SCRIPT_NAME.addr"