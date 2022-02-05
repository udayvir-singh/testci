FROM pandoc/minimal:2.17-alpine

RUN apk update && apk upgrade && apk add bash neovim

CMD ["make", "vimdoc"]
