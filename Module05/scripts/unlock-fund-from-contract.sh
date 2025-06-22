#!/bin/bash

source util.sh

# Enter the contract to unlock fund
echo ""
read -p "Unlock fund from contract: " CONTRACT

SCRIPT_FILE=$ASSETS_DIR/$CONTRACT.plutus
if [ ! -f "$SCRIPT_FILE" ] 
then
    >&2 echo "Plutus script file $SCRIPT_FILE does not exist"
    exit 1
fi

CONTRACT_ADDR_FILE=$ASSETS_DIR/$CONTRACT.addr
if [ ! -f "$CONTRACT_ADDR_FILE" ] 
then
    >&2 echo "Contract address file $CONTRACT_ADDR_FILE does not exist"
    exit 1
fi
CONTRACT_ADDRESS=$(cat $CONTRACT_ADDR_FILE)
echo "Contract address: $CONTRACT_ADDRESS"

# Choose utxo from contract to unlock
echo ""
echo "------------------------------------------------------------------"
echo "Select an UTxO from $CONTRACT address to unlock:"
echo "------------------------------------------------------------------"
echo ""
select_utxo $CONTRACT
TX_IN_TO_UNLOCK=${SELECTED_UTXO}

# Enter the receiver: alice or bob
echo ""
read -p "Who is the receiver? " RECEIVER

SKEY="$ASSETS_DIR/$RECEIVER.skey"
if [ ! -f "$SKEY" ] 
then
    >&2 echo "Private key file $SKEY does not exist"
    exit 1
fi

ADDR_FILE=$ASSETS_DIR/$RECEIVER.addr
if [ ! -f "$ADDR_FILE" ] 
then
    >&2 echo "Address file $ADDR_FILE does not exist"
    exit 1
fi

RECEIVER_ADDRESS=$(cat $ADDR_FILE)
echo "Receiver address: $RECEIVER_ADDRESS"

# Choose utxo from sender wallet to spend
echo ""
echo "------------------------------------------------------------------"
echo "Select an UTxO from $RECEIVER wallet as collateral:"
echo "------------------------------------------------------------------"
echo ""
select_utxo $RECEIVER
COLLATERAL=${SELECTED_UTXO}

# specify the attached JSON file for the datum
echo ""
read -p "You need attach a JSON file for the redeemer. What is the file name? " FILE
echo ""

REDEEMER_FILE=$ASSETS_DIR/data-files/$FILE.json
if [ ! -f "$REDEEMER_FILE" ] 
then
    >&2 echo "Data file $REDEEMER_FILE does not exist"
    exit 1
fi

# Raw files for transaction building
TMP_DIR=$ASSETS_DIR/tmp
mkdir -p "$TMP_DIR"
TX_RAW_FILE=$TMP_DIR/tx.draft
TX_SIGNED_FILE=$TMP_DIR/tx.signed

# Get protocol parameters
# PROTOCOL_PARAMS=$ASSETS_DIR/protocol.json
# cardano-cli query protocol-parameters --$NETWORK --out-file $PROTOCOL_PARAMS

# Build transaction
cardano-cli latest transaction build \
    --$NETWORK \
    --tx-in $TX_IN_TO_UNLOCK \
    --tx-in-script-file $SCRIPT_FILE \
    --tx-in-inline-datum-present \
    --tx-in-redeemer-file $REDEEMER_FILE \
    --tx-in-collateral $COLLATERAL \
    --change-address $RECEIVER_ADDRESS \
    --out-file $TX_RAW_FILE

# Sign transaction
cardano-cli latest transaction sign \
    --tx-body-file $TX_RAW_FILE \
    --$NETWORK \
    --signing-key-file $SKEY \
    --out-file $TX_SIGNED_FILE

# Submit
cardano-cli latest transaction submit \
    --$NETWORK \
    --tx-file $TX_SIGNED_FILE

# Transaction ID
TID=$(cardano-cli latest transaction txid --tx-file "$TX_SIGNED_FILE")
echo "Transaction id: $TID"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$TID"