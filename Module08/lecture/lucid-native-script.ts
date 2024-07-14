import {
    Lucid,
    Blockfrost,
    Address,
    MintingPolicy,
    PolicyId,
    Unit,
    fromText,
    Data,
    getAddressDetails,
    applyParamsToScript
} from "https://deno.land/x/lucid@0.10.7/mod.ts"
import { blockfrostKey, secretSeed } from "./secret.ts"

function readAmount(): bigint {
    const input = prompt("amount: ");
    return input ? BigInt(Number.parseInt(input)) : 1000000n;
}

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

const pkh: string = getAddressDetails(addr).paymentCredential?.hash || "";
console.log("own pubkey hash: " + pkh);

const mintingPolicy: MintingPolicy = lucid.utils.nativeScriptFromJson(
    {
        type: "sig", 
        keyHash: pkh
    }
);
console.log("Script type: " + mintingPolicy.type + ", Script: " + mintingPolicy.script);

const policyId: PolicyId = lucid.utils.mintingPolicyToId(mintingPolicy);
console.log("minting policy: " + policyId);

const unit: Unit = policyId + fromText("C2VN Native");

const amount: bigint = readAmount();

const tx = await lucid
    .newTx()
    .mintAssets({[unit]: amount})
    .attachMintingPolicy(mintingPolicy)
    .complete();

const signedTx = await tx.sign().complete();
const txHash = await signedTx.submit();
console.log("tid: " + txHash);