FROM --platform=amd64 alpine:latest

WORKDIR /data

RUN apk update && apk add gcc binutils nasm