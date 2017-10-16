FROM debian:jessie-slim

ARG TZ=Europe/Paris
ARG VTC_USER=vtc
ARG VTC_UID=1000
ARG VTC_VERSION=v0.11.1.0
ARG VTC_ARCHIVE=vertcoin-${VTC_VERSION}-linux-64bit.zip

ENV TZ $TZ

RUN useradd -m -u $VTC_UID $VTC_USER \
  && apt-get -qq -y update \
  && apt-get -qq -y install curl ca-certificates unzip \
  && curl -s -L https://github.com/vertcoin/vertcoin/releases/download/${VTC_VERSION}/${VTC_ARCHIVE} \
    --output ${VTC_ARCHIVE} \
  && unzip ${VTC_ARCHIVE} \
  && mv vertcoind /usr/local/bin \
  && mv vertcoin-cli /usr/local/bin \
  && mv vertcoin-tx /usr/local/bin \
  && rm -f vertcoin-*

USER $VTC_USER
WORKDIR /home/$VTC_USER

CMD ["vertcoind"]
