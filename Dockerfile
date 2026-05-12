# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ORCASLICER_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="OrcaSlicer (Snapmaker)" \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NO_GAMEPAD=true \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/orcaslicer-logo.png && \
  echo "**** add mozilla apt repo ****" && \
  install -d -m 0755 /etc/apt/keyrings && \
  curl -o \
    /etc/apt/keyrings/packages.mozilla.org.asc -L \
    https://packages.mozilla.org/apt/repo-signing-key.gpg && \
  echo \
    "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > \
    /etc/apt/sources.list.d/mozilla.list && \
  printf \
    "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n" > \
    /etc/apt/preferences.d/mozilla && \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-qt5 \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    libgstreamer-plugins-bad1.0 \
    libmspack0 \
    libwebkit2gtk-4.1-0 \
    libwx-perl \
    unzip && \
  echo "**** install snapmaker orcaslicer ****" && \
  if [ -z ${ORCASLICER_VERSION+x} ]; then \
    ORCASLICER_VERSION=$(curl -sX GET "https://api.github.com/repos/Snapmaker/OrcaSlicer/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "Building OrcaSlicer version: ${ORCASLICER_VERSION}" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/Snapmaker/OrcaSlicer/releases/latest" \
    | awk '/browser_download_url.*ubuntu.*zip/{print $4;exit}' FS='[""]') && \
  if [ -z "${DOWNLOAD_URL}" ]; then \
    echo "ERROR: Could not find Ubuntu zip download URL" && exit 1; \
  fi && \
  echo "Downloading from: ${DOWNLOAD_URL}" && \
  curl -o /tmp/orca.zip -L "${DOWNLOAD_URL}" && \
  unzip /tmp/orca.zip -d /tmp/orca_extracted && \
  chmod +x /tmp/orca_extracted/*.AppImage && \
  cd /tmp/orca_extracted && \
  ./*.AppImage --appimage-extract && \
  mv squashfs-root /opt/orcaslicer && \
  localedef -i en_GB -f UTF-8 en_GB.UTF-8 || true && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001
VOLUME /config
