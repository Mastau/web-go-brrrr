# syntax=docker/dockerfile:1.7

FROM golang:1.25.7-bookworm AS go-tools

ARG FFUF_VERSION=v2.1.0
ARG NUCLEI_VERSION=v3.8.0
ARG HTTPX_VERSION=v1.9.0
ARG SUBFINDER_VERSION=v2.14.0
ARG GAU_VERSION=v2.2.4

ENV CGO_ENABLED=0 \
    GOBIN=/out

RUN mkdir -p /out \
    && go install github.com/ffuf/ffuf/v2@${FFUF_VERSION} \
    && go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@${NUCLEI_VERSION} \
    && go install github.com/projectdiscovery/httpx/cmd/httpx@${HTTPX_VERSION} \
    && go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@${SUBFINDER_VERSION} \
    && go install github.com/lc/gau/v2/cmd/gau@${GAU_VERSION}

FROM rust:1.93-bookworm AS rust-tools

ARG FEROXBUSTER_VERSION=2.12.0
ARG DALFOX_VERSION=3.0.1

RUN cargo install --git https://github.com/epi052/feroxbuster.git --tag v${FEROXBUSTER_VERSION} --locked
RUN cargo install --git https://github.com/hahwul/dalfox.git --tag v${DALFOX_VERSION} --locked

FROM debian:12-slim

ARG LAB_USER=lab
ARG LAB_UID=1000
ARG LAB_GID=1000

LABEL org.opencontainers.image.title="CyberLab" \
      org.opencontainers.image.description="Terminal-first web security lab for authorized testing"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin \
    LAB_USER=${LAB_USER}

COPY docker/scripts/ /opt/cyberlab/build/

RUN chmod +x /opt/cyberlab/build/*.sh \
    && /opt/cyberlab/build/install-core.sh \
    && /opt/cyberlab/build/install-development.sh \
    && /opt/cyberlab/build/install-network.sh \
    && /opt/cyberlab/build/install-web.sh \
    && /opt/cyberlab/build/install-wordlists.sh \
    && groupadd --gid "${LAB_GID}" "${LAB_USER}" \
    && useradd --uid "${LAB_UID}" --gid "${LAB_GID}" --create-home --shell /usr/bin/zsh "${LAB_USER}" \
    && printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${LAB_USER}" > "/etc/sudoers.d/${LAB_USER}" \
    && chmod 0440 "/etc/sudoers.d/${LAB_USER}" \
    && /opt/cyberlab/build/finalize-image.sh

COPY --from=go-tools /out/ /usr/local/bin/
COPY --from=go-tools /usr/local/go/ /usr/local/go/
COPY --from=rust-tools /usr/local/cargo/bin/feroxbuster /usr/local/bin/feroxbuster
COPY --from=rust-tools /usr/local/cargo/bin/dalfox /usr/local/bin/dalfox
COPY config/shell/zshrc /etc/skel/.zshrc
COPY config/shell/zshrc /home/${LAB_USER}/.zshrc
COPY config/tmux/tmux.conf /etc/tmux.conf
COPY docker/entrypoint/entrypoint.sh /usr/local/bin/cyberlab-entrypoint

RUN chmod 0755 /usr/local/bin/cyberlab-entrypoint \
    && chown "${LAB_UID}:${LAB_GID}" "/home/${LAB_USER}/.zshrc" \
    && mkdir -p /workspace \
    && chown "${LAB_UID}:${LAB_GID}" /workspace

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/cyberlab-entrypoint"]
CMD ["zsh", "-l"]
