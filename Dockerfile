FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MODRINTH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Modrinth

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/modrinth-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    gnome-keyring && \
  if [ -z ${MODRINTH_VERSION+x} ]; then \
    MODRINTH_VERSION=$(curl -sX GET "https://api.github.com/repos/modrinth/code/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/modrinth.deb -L \
    "https://launcher-files.modrinth.com/versions/$(echo ${MODRINTH_VERSION}| sed 's/^v//g')/linux/Modrinth%20App_$(echo ${MODRINTH_VERSION}| sed 's/^v//g')_amd64.deb" && \
  apt-get install -y \
    /tmp/modrinth.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001
VOLUME /config
