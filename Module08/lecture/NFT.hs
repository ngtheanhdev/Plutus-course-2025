{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module NFT where

import           Plutus.V1.Ledger.Value     (flattenValue)
import           Plutus.V2.Ledger.Api       (BuiltinData,
                                             ScriptContext (scriptContextTxInfo),
                                             TokenName (unTokenName), TxOutRef,
                                             TxInInfo (txInInfoOutRef),
                                             TxInfo (txInfoInputs, txInfoMint))
import           PlutusTx                   (unsafeFromBuiltinData,
                                             CompiledCode, compile)
import           PlutusTx.Prelude           (Bool (False), Eq ((==)), any,
                                             traceIfFalse, ($), (&&))
import           Prelude                    (IO)
import           Utilities                  (wrapPolicy, writeCodeToFile)

{-# INLINABLE mkNFTPolicy #-}
mkNFTPolicy :: TxOutRef -> TokenName -> () -> ScriptContext -> Bool
mkNFTPolicy oref tn _ ctx = traceIfFalse "UTxO not consumed"   hasUTxO           &&
                            traceIfFalse "wrong amount minted" checkMintedAmount
  where
    info :: TxInfo
    info = scriptContextTxInfo ctx

    hasUTxO :: Bool
    hasUTxO = any (\i -> txInInfoOutRef i == oref) (txInfoInputs info)

    checkMintedAmount :: Bool
    checkMintedAmount = case flattenValue (txInfoMint info) of
        [(_, tn'', amt)] -> tn'' == tn && amt == 1
        _                -> False

{-# INLINABLE mkWrappedNFTPolicy #-}
mkWrappedNFTPolicy :: BuiltinData -> BuiltinData -> BuiltinData -> BuiltinData -> ()
mkWrappedNFTPolicy oref tn = wrapPolicy $ mkNFTPolicy (unsafeFromBuiltinData oref)
                                                      (unsafeFromBuiltinData tn)

nftCode :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinData -> BuiltinData -> ())
nftCode = $$(compile [|| mkWrappedNFTPolicy ||])

---------------------------------------------------------------------------------------------------
------------------------------------- HELPER FUNCTIONS --------------------------------------------

saveNFTCode :: IO ()
saveNFTCode = writeCodeToFile "assets/plutus-scripts/nft.plutus" nftCode

