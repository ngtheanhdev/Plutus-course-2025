# CARDANO NODE - OVERVIEW

```cnode
cardano-node run \
   --config "/mnt/d/cardano/cnode/preview/files/config.json" \
   --topology "/mnt/d/cardano/cnode/preview/files/topology.json" \
   --socket-path "/mnt/d/cardano/cnode/preview/sockets/node0.socket" \
   --database-path "/mnt/d/cardano/cnode/preview/db" \
   --host-addr 0.0.0.0 \
   --port 3001 
```

```cnode
export CARDANO_NODE_SOCKET_PATH=/mnt/d/cardano/cnode/preview/sockets/node0.socket
```

Link download Cardano node configuration run on testnet preview

```cnode
curl -O -J https://book.world.dev.cardano.org/environments/preview/config.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/db-sync-config.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/submit-api-config.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/topology.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/byron-genesis.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/shelley-genesis.json
curl -O -J https://book.world.dev.cardano.org/environments/preview/alonzo-genesis.json
```
