FROM robertinoiog/plutus-pioneer-program-4:v6

RUN wget https://github.com/IntersectMBO/cardano-node/releases/download/10.4.1/cardano-node-10.4.1-linux.tar.gz
RUN mkdir -p cardano-node
RUN tar -xzf cardano-node-10.4.1-linux.tar.gz -C cardano-node
RUN chmod +x ./cardano-node/bin/cardano-cli

RUN mv -f ./cardano-node/bin/cardano-node /usr/bin/cardano-node
RUN mv -f ./cardano-node/bin/cardano-cli /usr/bin/cardano-cli
RUN rm -rf ./cardano-node cardano-node-10.4.1-linux.tar.gz