{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Signed where

import Plutus.V2.Ledger.Api      (BuiltinData, CurrencySymbol,
                                  MintingPolicy, PubKeyHash,
                                  ScriptContext (scriptContextTxInfo),
                                  mkMintingPolicyScript)
import Plutus.V2.Ledger.Contexts (txSignedBy)
import PlutusTx                  (CompiledCode, compile, 
                                  applyCode, liftCode, 
                                  toBuiltinData, 
                                  unsafeFromBuiltinData)
import PlutusTx.Prelude          (Bool, traceIfFalse, ($), (.))
import Prelude                   (IO, Show (show))
import Text.Printf               (printf)
import Utilities                 (currencySymbol, wrapPolicy,
                                  writeCodeToFile, writePolicyToFile)

{-# INLINABLE mkSignedPolicy #-}
mkSignedPolicy :: PubKeyHash -> () -> ScriptContext -> Bool
mkSignedPolicy pkh _ ctx = traceIfFalse "missing signature" $ txSignedBy (scriptContextTxInfo ctx) pkh

{-# INLINABLE mkWrappedSignedPolicy #-}
mkWrappedSignedPolicy :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mkWrappedSignedPolicy pkh = wrapPolicy (mkSignedPolicy $ unsafeFromBuiltinData pkh)

-- Compile code chưa được apply tham số
signedCode :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinData -> ())
signedCode = $$(compile [|| mkWrappedSignedPolicy ||])

-- Apply tham số cho parameterized script 
signedPolicy :: PubKeyHash -> MintingPolicy
signedPolicy pkh = mkMintingPolicyScript $ signedCode `applyCode` liftCode (toBuiltinData pkh)

---------------------------------------------------------------------------------------------------
------------------------------------- HELPER FUNCTIONS --------------------------------------------
-- Phiên bản policy chưa apply tham số
saveSignedCode :: IO ()
saveSignedCode = writeCodeToFile "assets/plutus-scripts/signed.plutus" signedCode

-- Phiên bản policy hoàn chỉnh đã apply tham số
saveSignedPolicy :: PubKeyHash -> IO ()
saveSignedPolicy pkh = writePolicyToFile (printf "assets/signed-%s.plutus" $ show pkh) $ signedPolicy pkh

signedCurrencySymbol :: PubKeyHash -> CurrencySymbol
signedCurrencySymbol = currencySymbol . signedPolicy
