#!/bin/sh

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
	
	first="YES"
	long="NO"

	SOURCE=""
	PAR=""
	TXT=""

	echo "$line" | tr " " "\n" | while read -r token
	do
		if [[ "$long" == "YES" ]]; then
			TXT="$TXT $token"
		else
			if [[ $token =~ ^: ]]; then
				if [[ "$first" == "YES" ]]
				then
					SOURCE="${token:1:512}"
				else
					long="YES"
					TXT="${token:1:512}"
				fi
			else
				[[ "a$CMD" == "a" ]] && CMD="$token" || PAR="$PAR $token"
			fi
		fi
		first="NO"
	done

	echo "source $SOURCE cmd $CMD par $PAR txt $TXT"

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
		PRIVMSG)
			send "PRIVMSG $PAR :$TXT hello $SOURCE"
	esac

done
