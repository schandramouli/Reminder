#!/bin/sh

if [ -d "./cal" ]; then
:
else
mkdir ./cal
fi
touch ./cal/blank
curd=$(date +"%-d %-m %-Y")

menu() {

mo="$(zenity --list --column="Options" --text="Select One of the Below options" --height=200 --width=200 \
 "Add A New Reminder" "Edit A Reminder" "View A Reminder" "View All Reminders" "Delete A Reminder"  "Delete All Reminders" "Exit")"
if [ "$?" = 1 ] ;then
exitp
fi

case "$mo" in
"Add A New Reminder") 
set $curd
add "Add" $1 $2 $3 "./cal/blank" ""
;;
"Edit A Reminder") edit;;
"View A Reminder") view "one";;
"View All Reminders") view "all";;
"Delete A Reminder") del "one";;
"Delete All Reminders") del "all";;
"Exit") exit 0;;
*) zenity --error --text="Incorrect Option" --title="Error"
esac

}

exitp(){
zenity --question --title="Confirm" --text="Do you want to Quit the Application ? "
if [ "$?" = 0 ] ;then
exit 0
else
main
fi
}



q(){
zenity --question --title="Confirm" --text="Do you want to Quit $1 ? "
if [ "$?" = 0 ];then
main
fi 
}


add() {

while : 
do
date=$(zenity --calendar --title="$1 A Reminder" --text="Enter the $6date of the Reminder" --height=200 --width=200 --date-format="%-d%-m%-Y" --day="$2" --month="$3" --year="$4" )

if [ -n "$date" ] ; then
break
else
q "$1ing Reminder"
fi
done

while :
do
rem=$(zenity --text-info --editable --title="Reminder" --text="What would you like us to remind? " --height=500 --width=400 --filename="$5")

if [ "$?" = 1 ]; then
q "$1 Reminder"
elif [ -n "$rem" ] ;then
echo $rem>> ./cal/d_$date
break
else
zenity --error --title="No Reminder" --text="The Reminder field cannot be Blank."
fi
done
zenity --info --title "Reminder Saved" --text="Your Reminder was saved successfully."
}

main() {
while :
do
menu
done
}

edit(){
while :
do
ed=$(zenity --calendar --title="Edit A Reminder" --text="Date of the Reminder you want to edit : " --date-format="%-d %-m %-Y")
set $ed

if [ -n "$ed" ] ; then
break
else
q "Editing Reminder"
fi
done

if [ -f "./cal/d_$1$2$3" ]; then
oldrem=$(cat ./cal/d_$1$2$3)
echo "$oldrem" > ./cal/tmp_$$
rm -f ./cal/d_$1$2$3
add "Edit" $1 $2 $3 "./cal/tmp_$$" "New "
rm -f ./cal/tmp_$$
else
zenity --error --title="Reminder Not Found" --text="No Reminders Found on the Specific Date. "
fi
}

view(){
if [ "$1"  = "one" ] ; then
while : 
do 
vd=$(zenity --calendar --title="View A Reminder" --text="Date of the Reminder you want to View : " --date-format="%-d %-m %-Y")
set $vd
if [ -n "$vd" ] ;then
break
else
q "Viewing Reminder"
fi 
done
if [ -f "./cal/d_$1$2$3" ]; then
zenity --text-info --filename="./cal/d_$1$2$3" --title="View A Reminder" --text="Remind me About : " >/dev/null
else
zenity --error --title="Reminder Not Found" --text="No Reminders Found on the Specific Date. "
fi
else
echo "">>./cal/tmp_$$
for file in $(ls ./cal/ | grep "d_")
do
echo "\n$file">>./cal/tmp_$$
cat ./cal/$file >> ./cal/tmp_$$
done
zenity --text-info --title="View All Reminders" --filename="./cal/tmp_$$" --text="Remind me About : " >/dev/null
rm -f ./cal/tmp_$$
fi
}

del(){
if [ "$1"  = "one" ] ; then
 while : 
 do 
 dd=$(zenity --calendar --title="Delete A Reminder" --text="Date of the Reminder you want to Delete : " --date-format="%-d %-m %-Y")
 set $dd
  if [ -n "$dd" ] ;then
   break
  else
   q "Deleting Reminder"
  fi 
 done
 if [ -f "./cal/d_$1$2$3" ]; then
 zenity --question --title="Confirm Delete" --text="Are you sure you want to delete the reminder ? " 
  if [ "$?" = 0 ];then
   rm -f ./cal/d_$1$2$3
   zenity --info --title="Deleted" --text="Reminder Successfully Deleted"
  fi
 else
  zenity --error --title="Reminder Not Found" --text="No Reminders Found on the Specific Date. "
 fi
else
 zenity --question --title="Confirm Delete" --text="Are you sure you want to delete all the reminders ? "
 if [ "$?" = 0 ];then
  for file in $(ls ./cal/ | grep "d_")
  do
  rm -f ./cal/$file
  done
  zenity --info --title="Deleted" --text="All Reminders Successfully Deleted"
 fi
fi
}


main
