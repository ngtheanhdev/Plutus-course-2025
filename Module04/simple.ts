// Trang chủ Lucid tại  --> https://lucid.spacebudz.io/
// Trang chủ Blockfrost --> https://blockfrost.io 
//
//
//


import { Blockfrost, Lucid } from "https://deno.land/x/lucid/mod.ts";

const lucid = await Lucid.new(
    new Blockfrost(
        "https://cardano-preview.blockfrost.io/api/v0", "preview4QbiejGzlyhUgfvyXZNf8lDEIFjCHjP0",
    ),
    "Preview",
);


// const privateKey = lucid.utils.generatePrivateKey(); // Bech32 encoded private key
// console.log(privateKey);
// lucid.selectWalletFromPrivateKey(privateKey);

const Alice = "leisure come endorse situate perfect slender helmet pond next host mean great program antenna ecology used scheme indoor various conduct border swamp spread spin"


lucid.selectWalletFromSeed(Alice);
//console.log(lucid.utils.getAddressDetails(await lucid.wallet.address()));

const Bob_addr = "addr_test1qqew6jaz63u389gwnp8w92qntetzxs6j9222pn4cnej672vazs7a6wnrseqggj4d4ur43yq9e23r4q0m879t7efyhzjq8mvzua";
const tx = await lucid.newTx()
    .payToAddress(Bob_addr, { lovelace: 5000000n })
    .complete();

const signedTx = await tx.sign().complete();
const txHash = await signedTx.submit();
console.log(`Mã giao dịch là ${txHash}`);