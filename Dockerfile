FROM debian:stretch-slim

ARG TZ=Europe/Paris
ARG VTC_USER=vtc
ARG VTC_UID=1000
ARG VTC_VERSION=0.14.0
ARG VTC_ARCHIVE=vertcoind-v${VTC_VERSION}-linux-amd64.zip
ARG VTC_SIG=${VTC_ARCHIVE}.sig
ARG VTC_URL=https://github.com/vertcoin-project/vertcoin-core/releases/download
ARG VTC_PGP=0x425776e2f9e5bab8
ARG VTC_BIN=/usr/local/bin

ENV TZ $TZ

RUN useradd -m -u $VTC_UID $VTC_USER \
  && apt-get -qq -y update \
  && apt-get -qq -y install wget unzip gpg \
  && wget -q ${VTC_URL}/${VTC_VERSION}/${VTC_ARCHIVE} \
  && wget -q ${VTC_URL}/${VTC_VERSION}/${VTC_SIG} \
  && gpg --keyserver pgp.mit.edu --receive-keys ${VTC_PGP} \
  && gpg --verify ${VTC_SIG} ${VTC_ARCHIVE} \
  && unzip -d ${VTC_BIN} ${VTC_ARCHIVE} \
  && chmod -R +x ${VTC_BIN} \
  && rm -f ${VTC_ARCHIVE} ${VTC_SIG}

EXPOSE 5888 5889

USER $VTC_USER
WORKDIR /home/$VTC_USER

CMD ["vertcoind"]
