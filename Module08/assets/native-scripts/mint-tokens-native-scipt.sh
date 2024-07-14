#!/bin/bash

WALLET_PATH="./../wallets"

ISSUER_ADDR=$(cat $WALLET_PATH/alice.addr)
SKEY=$WALLET_PATH/alice.skey

TX_IN="1ee9aeead3bbb52e981ddb49319bc8e0dc13ec30241e61f1eb697672faa77760#1"

RECEIVER_ADDR=$ISSUER_ADDR

MINT_SCRIPT_FILE_PATH="./signed-policy.script"
POLICY_ID=$(cardano-cli transaction policyid --script-file $MINT_SCRIPT_FILE_PATH)

TOKEN_NAME="C2VN"
TOKEN_HEXSTRING=$(xxd -pu <<< $TOKEN_NAME)
TOKEN_HEX=${TOKEN_HEXSTRING::-2}

ASSET_ID=$POLICY_ID.$TOKEN_HEX

QUANTITY=100

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.json

cardano-cli transaction build \
--babbage-era \
--testnet-magic 2 \
--tx-in $TX_IN \
--tx-out $RECEIVER_ADDR+"1500000 + $QUANTITY $ASSET_ID" \
--mint "$QUANTITY $ASSET_ID" \
--mint-script-file $MINT_SCRIPT_FILE_PATH \
--change-address $ISSUER_ADDR \
--protocol-params-file protocol.json \
--out-file tx.draft

cardano-cli transaction sign \
--signing-key-file $SKEY \
--testnet-magic 2 \
--tx-body-file tx.draft \
--out-file tx.signed

cardano-cli transaction submit \
--tx-file tx.signed \
--testnet-magic 2

# Transaction ID
TID=$(cardano-cli transaction txid --tx-file "tx.signed")
echo "Transaction id: $TID"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$TID"