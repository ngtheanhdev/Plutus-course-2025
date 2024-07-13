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

const plutusFilePath = "./../assets/plutus-scripts/signed.plutus"
const cborCode = JSON.parse(await Deno.readTextFile(plutusFilePath)).cborHex;

const signedPolicy: MintingPolicy = {
    type: "PlutusV2",
    script: applyParamsToScript(
        cborCode,
        [pkh],
    )
};

const policyId: PolicyId = lucid.utils.mintingPolicyToId(signedPolicy);
console.log("minting policy: " + policyId);

const unit: Unit = policyId + fromText("C2VN Signed");

const amount: bigint = readAmount();

const tx = await lucid
    .newTx()
    .mintAssets({[unit]: amount}, Data.void())
    .attachMintingPolicy(signedPolicy)
    .addSignerKey(pkh)
    .complete();

const signedTx = await tx.sign().complete();
const txHash = await signedTx.submit();
console.log("tid: " + txHash);