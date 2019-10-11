# Usage: docker run --restart=always -v /var/data/blockchain-xmr:/root/.bitmonero -p 18080:18080 -p 18081:18081 --name=monerod -td kannix/monero-full-node
FROM ubuntu:18.04 AS build

ENV MONERO_VERSION=0.14.1.0 MONERO_SHA256=b95903a0f1b0c15cefdf59814fe12e3597a3322ae6d0567c732f0ab79c877724

RUN apt-get update && apt-get install -y curl bzip2

WORKDIR /root

RUN curl https://downloads.getmonero.org/cli/monero-linux-armv7-v$MONERO_VERSION.tar.bz2 -O &&\
  echo "$MONERO_SHA256  monero-linux-armv7-v$MONERO_VERSION.tar.bz2" | sha256sum -c - &&\
  tar -xzvf monero-linux-armv7-v$MONERO_VERSION.tar.bz2 &&\
  rm monero-linux-armv7-v$MONERO_VERSION.tar.bz2 &&\
  cp ./monero-arm-linux-gnueabihf/monerod . &&\
  rm -r monero-*

#FROM ubuntu:18.04

#RUN useradd -ms /bin/bash monero
#USER monero
#WORKDIR /home/monero

#COPY --chown=monero:monero --from=build /root/monerod /home/monero/monerod

# blockchain loaction
VOLUME /root/.bitmonero

EXPOSE 18080 18081

ENTRYPOINT ["./monerod"]
CMD ["--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]
