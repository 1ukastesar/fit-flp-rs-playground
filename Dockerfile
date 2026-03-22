FROM quay.io/jupyter/minimal-notebook:latest

USER root

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential pkg-config libssl-dev libzmq3-dev curl && \
    rm -rf /var/lib/apt/lists/*

USER ${NB_USER}

ENV PATH="/home/jovyan/.cargo/bin:$PATH"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    cargo install --locked evcxr_jupyter && \
    evcxr_jupyter --install
