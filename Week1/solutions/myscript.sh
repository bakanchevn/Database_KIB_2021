#!/bin/bash
echo "Welcome to the DaveCoffeeshop!"

if [ -f "$HOME"/davecoffeeshop.db ] 
then
	echo "$HOME/davecoffeeshop.db, using existing database"
else 
	echo "$HOME/davecoffeeshop.db missing => creating new file"
	touch "$HOME/davecoffeeshop.db"
fi
echo "To log order, enter LOG"
echo "To end session, enter EOS"
echo "To end business day, enter EOD"

flag=$(( 0 ))
LOG="LOG"
EOD="EOD"
EOS="EOS"

while [ $flag -lt 1 ]
do
	read -r str
	if [ "$str" = "$LOG" ]
	then
		echo -n "Barista name: "
		read -r name
		echo -n "Drinking: "
		read -r drink
		if [ "$drink" = "RAF" ]
		then
			echo "$name;$drink;200" >> "$HOME"/davecoffeeshop.db
			echo "Order was saved!"
		elif [ "$drink" = "CAP" ]
		then
			echo "$name;$drink;150" >> "$HOME"/davecoffeeshop.db
			echo "Order was saved!"
		elif [ "$drink" = "AME" ]
		then
			echo "$name;$drink;100" >> "$HOME"/davecoffeeshop.db
			echo "Order was saved!"
		elif [ "$drink" = "ESP" ]
		then
			echo "$name;$drink;120" >> "$HOME"/davecoffeeshop.db
			echo "Order was saved!"
		elif [ "$drink" = "LAT" ]
		then
			echo "$name;$drink;170" >> "$HOME"/davecoffeeshop.db
			echo "Order was saved!"
		fi
	elif [ "$str" = "$EOS" ]
	then
		flag+=1
		echo "End of session"
	elif [ "$str" = "$EOD" ]
	then
		echo "End of day. Result:"
		awk -F ";" '{
			array[$1]+=$3;
		} END {
			for (i in array)
				print i";"array[i]}' "$HOME"/davecoffeeshop.db | sort -t ";" -k2 -n -r
	else 
		echo "Bad command. Try again"
	fi
done
