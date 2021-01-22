#!/bin/zsh

	line="$@"

	first="YES"
	long="NO"

	SOURCE=""
	CMD=""
	PAR=""
	TXT=""

	echo "$line" | tr " " "\n" | while read -r token
	do
		if [[ "$long" == "YES" ]]; then
			TXT="$TXT $token"
		else
			if [[ ${token:0:1} == : ]]; then
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
	PAR="${PAR:1:512}"
	echo "source $SOURCE tcmd $CMD par $PAR txt $TXT"
