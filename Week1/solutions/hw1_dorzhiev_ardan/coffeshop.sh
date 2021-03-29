echo 'Welcome to the Dave Coffeeshop!'

if [ -f davecoffeeshop.db ]; then 
 echo 'davecoffeeshop.db exists, using existing database'
else
 echo 'davecoffeeshop.db not exists => creating db file'
 touch davecoffeeshop.db

 echo 'success' 
fi

echo 'To log order, enter LOG
To end session, enter EOS
To end business day, enter EOD'

while read command
 do 
  if [ $command = 'LOG' ]; then 
   echo 'Enter Barista' 
   read barista
   echo 'Enter Drink'
   read in_drink
   echo "Barista name: $barista"
   echo "Drinking: $in_drink"
   
   case $in_drink in
     "AME")
          price=100
          ;;
     "ESP")
          price=120
          ;;
     "CAP")
          price=150
          ;;
     "LAT")
          price=170
          ;;
     "RAF")
          price=200
          ;;
         *)
	  price=0
          ;;
   esac
   
   if (( price > 0 )); then    
    echo "$barista;$in_drink;$price" >> davecoffeeshop.db
    echo 'Order was saved!'
   else
    echo Invalid drink c, ignoring
   fi
   
  elif [ $command = 'EOS' ]; then
   echo 'End of Session' 
   exit
  elif [ $command = 'EOD' ]; then
   echo 'End of Day!'
   
   cat davecoffeeshop.db | sort -nk1 -t ";" | awk -F";" 'BEGIN {OFS=";" }\
   ($1 == last || last == "") {sum += $3} ($1 != last && last != "")\
   {print last, sum; sum = $3} {last = $1} END {print last, sum}' | sort -nrk2 -t ";" 

  else 
   echo 'WRONG COMMAND. USE ONLY LOG, EOD, EOS'
  fi
done
