ARG ARG_IMAGE_FROM=quay.io/fedora/fedora-coreos:stable
FROM ${ARG_IMAGE_FROM}

# General variables
ENV IMAGE_NAME="fedora-coreos-k3s" \
    IMAGE_SUMMARY="Fedora CoreOS K3s image" \
    IMAGE_DESCRIPTION="Fedora CoreOS based image for installing and running K3s clusters" \
    IMAGE_TITLE="Fedora CoreOS K3s image"

FROM quay.io/fedora/fedora-coreos:stable

ADD --chown=root:root --chmod=0700 conf/prepare.sh /tmp/prepare.sh

ARG INSTALL_K3S_CHANNEL=stable
RUN set -eu && /tmp/prepare.sh; rm -f /tmp/prepare.sh

# Labels
LABEL name="${IMAGE_NAME}" \
      summary="${IMAGE_SUMMARY}" \
      description="${IMAGE_DESCRIPTION}" \
      maintainer="Job Céspedes Ortiz <jobcespedes@krestomatio.com>" \
      org.opencontainers.image.title="${IMAGE_TITLE}" \
      org.opencontainers.image.authors="Job Céspedes Ortiz <jobcespedes@krestomatio.com>" \
      org.opencontainers.image.description="${IMAGE_DESCRIPTION}" \
      io.k8s.description="${IMAGE_DESCRIPTION}" \
      io.k8s.display-name="${IMAGE_TITLE}" \
      io.openshift.tags="${IMAGE_NAME},fedora-coreos"
