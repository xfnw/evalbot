FROM alpine:3.12
RUN apk add openssl zsh
WORKDIR /evalbot
ADD . /evalbot
CMD ["zsh","evalbot.sh","irc.tilde.chat:6697","evalbot","#chaos"]
