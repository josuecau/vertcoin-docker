FROM debian:stretch-slim

ARG TZ=Europe/Paris
ARG VTC_USER=vtc
ARG VTC_UID=1000
ARG VTC_VERSION=0.12.0
ARG VTC_ARCHIVE=vertcoin-v${VTC_VERSION}-linux-64bit.zip
ARG VTC_SIG=${VTC_ARCHIVE}.sig
ARG VTC_PGP=0x04E9BCFB4E777CA3

ENV TZ $TZ

RUN useradd -m -u $VTC_UID $VTC_USER \
  && apt-get -qq -y update \
  && apt-get -qq -y install wget unzip gpg \
  && wget -q https://github.com/vertcoin/vertcoin/releases/download/${VTC_VERSION}/${VTC_ARCHIVE} \
  && wget -q https://github.com/vertcoin/vertcoin/releases/download/${VTC_VERSION}/${VTC_SIG} \
  && gpg --keyserver pgp.mit.edu --receive-keys ${VTC_PGP} \
  && gpg --verify ${VTC_SIG} ${VTC_ARCHIVE} \
  && unzip ${VTC_ARCHIVE} \
  && mv vertcoind /usr/local/bin \
  && mv vertcoin-cli /usr/local/bin \
  && mv vertcoin-tx /usr/local/bin \
  && rm -f vertcoin-*

EXPOSE 5888 5889

USER $VTC_USER
WORKDIR /home/$VTC_USER

CMD ["vertcoind"]
