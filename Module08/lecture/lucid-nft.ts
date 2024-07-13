import {
    Lucid,
    Blockfrost,
    Address,
    MintingPolicy,
    PolicyId,
    Unit,
    fromText,
    Data,
    Constr,
    applyParamsToScript
} from "https://deno.land/x/lucid@0.10.7/mod.ts"
import { blockfrostKey, secretSeed } from "./secret.ts"

// set blockfrost endpoint
const lucid = await Lucid.new(
    new Blockfrost(
        "https://cardano-preview.blockfrost.io/api/v0",
        blockfrostKey
    ),
    "Preview"
);

// load local stored seed as a wallet into lucid
lucid.selectWalletFromSeed(secretSeed);
const addr: Address = await lucid.wallet.address();
console.log("own address: " + addr);

const utxos = await lucid.utxosAt(addr);
const utxo = utxos[0];
console.log("utxo: " + utxo.txHash + "#" + utxo.outputIndex);

const outRef = new Constr(0, [
    new Constr(0, [utxo.txHash]),
    BigInt(utxo.outputIndex),
]);

const plutusFilePath = "./../assets/plutus-scripts/nft.plutus"
const cborCode = JSON.parse(await Deno.readTextFile(plutusFilePath)).cborHex;
const tn = fromText("C2VN NFT");

const nftPolicy: MintingPolicy = {
    type: "PlutusV2",
    script: applyParamsToScript(
        cborCode,
        [outRef, tn]
    )
};

const policyId: PolicyId = lucid.utils.mintingPolicyToId(nftPolicy);
console.log("minting policy: " + policyId);

const unit: Unit = policyId + tn;

const tx = await lucid
    .newTx()
    .mintAssets({[unit]: 1n}, Data.void())
    .attachMintingPolicy(nftPolicy)
    .collectFrom([utxo])
    .complete();

const signedTx = await tx.sign().complete();
const txHash = await signedTx.submit();
console.log("tid: " + txHash);