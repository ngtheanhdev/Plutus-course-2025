# Off-chain Code With Kuber


```ghci
cabal update
cabal repl Week03
:set -XOverloadedStrings
import Utilities
import Plutus.V2.Ledger.Api
import Vesting
:set prompt "Plutus.Vesting> "
```

```ghci
pkh = PubKeyHash $ toBuiltin $bytesFromHex "your-payment-key-hash"
pkh
:t pkh
```

```ghci
printVestingDatumJSON pkh "2024-06-25T00:00:00Z"
```

```bash
cardano-cli address build --testnet-magic 2 --payment-script-file ./code/Week03/assets/vesting.plutus
```

