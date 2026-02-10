FROM ubuntu:noble
RUN apt-get update
RUN apt-get --yes install software-properties-common
RUN add-apt-repository ppa:isc/bind
RUN apt-get update
RUN apt-get --yes install build-essential bind9-dev pkg-config liburcu-dev libuv1-dev libssl-dev libcap2-dev libjemalloc-dev wget
WORKDIR /build
ARG bind_url="https://ppa.launchpadcontent.net/isc/bind/ubuntu/pool/main/b/bind9"
ARG bind_ver="9.20.16"
RUN wget https://ppa.launchpadcontent.net/isc/bind/ubuntu/pool/main/b/bind9/bind9_${bind_ver}.orig.tar.xz --output-document=bind9.tar.xz
RUN tar -xf bind9.tar.xz
WORKDIR /build/bind-${bind_ver}
RUN ./configure --disable-doh --enable-full-report
WORKDIR /build/filter
COPY Makefile filter-a-cond.c filter-aaaa-cond.c .
RUN cp /build/bind-${bind_ver}/config.h .
RUN make all
