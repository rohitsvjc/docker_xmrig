FROM alpine:edge

RUN apk add --update --no-cache --virtual build-deps build-base cmake git \
    && apk add --update --no-cache libuv-dev libmicrohttpd-dev libressl-dev \
    && git clone https://github.com/xmrig/xmrig \
    && sed -i 's/kDefaultDonateLevel = 5/kDefaultDonateLevel = 0/g' /xmrig/src/donate.h \
    && sed -i 's/kMinimumDonateLevel = 1/kMinimumDonateLevel = 0/g' /xmrig/src/donate.h \
    && mkdir /xmrig/build \
    && cd /xmrig/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HWLOC=OFF .. \
    && make \
    && apk del build-deps

RUN adduser -S -D -H -h /xmrig monero
USER monero
WORKDIR /xmrig

ENTRYPOINT  ["./build/xmrig"]

CMD ["--url=pool.minexmr.com:7777", \
     "--user=8Bchi3J8r4C1nSwB1wW4AFjkvr9FaQKpj2mMWxiDNgkTRBragUrY1Nv4NoYWrurX3B9zXYCS4wY59iqXTqvtKg6DKSQY4Tg", \
     "--pass=docker_hub_miner", \
     "-k", "--max-cpu-usage=100", "--coin=xmr"]
