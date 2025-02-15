#ARG BASE_IMAGE=kinoite-main
#FROM ghcr.io/ublue-os/${BASE_IMAGE}:latest
FROM quay.io/fedora-ostree-desktops/kinoite:41

COPY build.sh /tmp/build.sh
COPY scripts/shared/packages.sh /tmp/packages.sh

COPY files/shared /

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    /tmp/packages.sh && \
    ln - /usr/lib/os-release /etc/os-release && \
    ostree container commit
