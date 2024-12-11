FROM rust:1.82-slim-bookworm as build

WORKDIR /app
RUN apt-get update && apt-get install --assume-yes pkg-config libssl-dev
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

ADD ./server ./server
ADD ./client ./client
ADD ./cli ./cli
RUN OPENSSL_STATIC=1 OPENSSL_NO_VENDOR=1 cargo build --release


FROM debian:bookworm-slim
RUN apt update && apt install -y openssl
COPY --from=build /app/target/release/localtunnel /usr/local/bin
