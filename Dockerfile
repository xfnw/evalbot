FROM alpine:latest
RUN apk add libressl zsh
WORKDIR /evalbot
ADD . /evalbot
CMD ["zsh evalbot.sh","irc.tilde.chat:6697","evalbot","#chaos"]
