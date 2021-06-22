#!/bin/zsh

DEETS="$1"
NICK="$2"
JOIN="$3"


onconnect(){
send "NICK $NICK"
}
send(){
echo "> $1"
printf "%b\r\n" "$1" >> sock
}


echo -e "USER $NICK 0 * :shell evaluation bot\r\n" > sock
onconnect

tail -f sock | openssl s_client "$DEETS" | while read -r raw
do
	line=$(printf %b "$raw" | tr -d $'\r')

	echo "< $line"
	source tokenize.sh "$line"

	case "$CMD" in
		PING)
			send "PONG :$PAR$TXT"
			;;
		001)
			send "JOIN $JOIN"
			;;
		433)
			NICK="$NICK"'_'
			onconnect
			;;
		INVITE)
			send "JOIN $TXT"
			;;
		PRIVMSG)
			[[ "${TXT%% *}" == "$NICK:" ]] &&
				zsh -c "${TXT#* }" 2>&1 | while IFS= read -r outp
							do
								send "PRIVMSG $PAR :$outp"
							done &
	esac
	eval set honk honk honk honk # clear the number vars so it wont repeat itself

done
