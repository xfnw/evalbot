FROM alpine:latest
RUN apk add libressl zsh
WORKDIR /evalbot
ADD . /evalbot
CMD ["zsh evalbot.sh","tilde.chat:6697","evalbot","#chaos"]
