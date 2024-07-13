{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module AssetFunctions where

import Plutus.V1.Ledger.Value ( CurrencySymbol, 
                                TokenName,
                                AssetClass, Value,
                                adaSymbol, adaToken,
                                singleton, assetClass, 
                                assetClassValue,
                                assetClassValueOf,
                                flattenValue )
import PlutusTx.Monoid        ( mconcat, inv, gsub )
import PlutusTx.Prelude       ( Integer, (<>))

-- ADA
ada :: AssetClass
ada = assetClass adaSymbol adaToken

someAdaValue :: Value
someAdaValue = assetClassValue ada 1000000

adaAmount :: Integer
adaAmount = assetClassValueOf someAdaValue ada

-- Custom tokens
token1 :: AssetClass
token1 = assetClass "ab11" "TK1"

token2 :: AssetClass
token2 = assetClass "ab11" "TK2"

val1 :: Value
val1 = assetClassValue token1 1000

val2 :: Value
val2 = assetClassValue token2 2000

val3 :: Value
val3 = singleton "cd33" "TK3" 3000


-- Some operations with the Value type

sumVal12 :: Value
sumVal12 = val1 <> val2

sumVal133 :: Value
sumVal133 = val1 <> val3 <> val3

sumVal123 :: Value
sumVal123 = mconcat [val1, val2, val3]

amountOfToken1 :: Integer
amountOfToken1 = assetClassValueOf sumVal123 token1


subVal1 :: Value
subVal1 = gsub sumVal123 sumVal12

subVal2 :: Value
subVal2 = gsub val1 val3


invVal1 :: Value
invVal1 = inv val1

invVal2 :: Value
invVal2 = inv subVal2


flattenVal :: [(CurrencySymbol, TokenName, Integer)]
flattenVal = flattenValue sumVal123