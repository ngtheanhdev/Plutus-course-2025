#!/bin/bash

source util.sh

# Enter sender name: alice or bob
echo ""
read -p "Who is the sender? " SENDER

SKEY="$ASSETS_DIR/$SENDER.skey"
if [ ! -f "$SKEY" ] 
then
    >&2 echo "Private key file $SKEY does not exist"
    exit 1
fi

ADDR_FILE=$ASSETS_DIR/$SENDER.addr
if [ ! -f "$ADDR_FILE" ] 
then
    >&2 echo "Address file $ADDR_FILE does not exist"
    exit 1
fi

ADDRESS=$(cat $ADDR_FILE)
echo "Sender address: $ADDRESS"

# Choose utxo from sender wallet to spend
echo ""
echo "------------------------------------------------------------------"
echo "Select an UTxO from $SENDER wallet to spend:"
echo "------------------------------------------------------------------"
echo ""
select_utxo $SENDER
TX_IN=${SELECTED_UTXO}

# Enter amount to send
echo ""
read -p "How many ADA will you send? " ADA
LOVELACE_TO_SEND=$((ADA * 1000000))


# Enter the contract to send fund
echo ""
read -p "Enter the contract name to send: " CONTRACT

CONTRACT_ADDR_FILE=$ASSETS_DIR/$CONTRACT.addr
if [ ! -f "$CONTRACT_ADDR_FILE" ] 
then
    >&2 echo "Contract address file $CONTRACT_ADDR_FILE does not exist"
    exit 1
fi
CONTRACT_ADDRESS=$(cat $CONTRACT_ADDR_FILE)
echo "Contract address: $CONTRACT_ADDRESS"

# specify the attached JSON file for the datum
echo ""
read -p "You need attach a JSON file for the datum. What is the file name? " FILE
echo ""

DATUM_FILE=$ASSETS_DIR/data-files/$FILE.json
if [ ! -f "$DATUM_FILE" ] 
then
    >&2 echo "Data file $DATUM_FILE does not exist"
    exit 1
fi

# Raw files for transaction building
TMP_DIR=$ASSETS_DIR/tmp
mkdir -p "$TMP_DIR"
TX_RAW_FILE=$TMP_DIR/tx.draft
TX_SIGNED_FILE=$TMP_DIR/tx.signed

# Build transaction
cardano-cli latest transaction build \
    --$NETWORK \
    --tx-in $TX_IN \
    --tx-out $CONTRACT_ADDRESS+$LOVELACE_TO_SEND \
    --tx-out-inline-datum-file $DATUM_FILE \
    --change-address $ADDRESS \
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