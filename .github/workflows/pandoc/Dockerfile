FROM pandoc/minimal:2.17-alpine

RUN apk update && apk upgrade && apk add make bash curl coreutils neovim

WORKDIR /build

COPY scripts   ./scripts
COPY Makefile  ./
COPY README.md ./

RUN mkdir doc

RUN ["make", "vimdoc"]

RUN ls ./doc
