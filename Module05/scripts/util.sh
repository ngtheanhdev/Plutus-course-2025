#!/bin/bash

NETWORK="testnet-magic 2"
ASSETS_DIR=./../assets

function select_utxo() {
	TMP_DIR=$ASSETS_DIR/tmp
	rm -f -r $TMP_DIR
	mkdir $TMP_DIR
	touch $TMP_DIR/utxos.txt
	UTXOS_FILE="$TMP_DIR/utxos.txt"
	ADDRESS_NAME=$1

	./balance.sh $ADDRESS_NAME > $UTXOS_FILE
	
	NUM_OF_LINES=$(wc -l < $UTXOS_FILE)
    # Check if the address is empty
    if [ "$NUM_OF_LINES" -lt 3 ]; then
        >&2 echo "There are no UTxOs available in the address."
        exit 1
    fi

	tail -n +3 $UTXOS_FILE > $TMP_DIR/tmp.txt

	n=1
	while read -r line
	do
	  echo "$n: $line"
	  n=$((n+1))
	done < $TMP_DIR/tmp.txt

	echo ""
	read -p 'Select UTXO row number: ' TMP

	while ! [[ "$TMP" =~ ^[0-9]+$ ]] || (( TMP < 1 || TMP > n-1 )); do
        echo "Invalid input. Please enter a valid number within the range."
        read -p 'Select UTXO row number: ' TMP
    done

	TX_ROW_NUM="$(($TMP+2))"
	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $UTXOS_FILE)
	SELECTED_UTXO="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
	SELECTED_UTXO_LOVELACE=$(echo $TX_ROW | awk '{ print $3 }')

	echo "Ok, you selected $SELECTED_UTXO with $SELECTED_UTXO_LOVELACE lovelace."
}
