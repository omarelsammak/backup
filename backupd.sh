#! /bin/bash

dir=$1

backupdir=$2

sleeptime=$3

backupcounter=$4

date=$(date '+%Y-%m-%d-%H-%M-%S')

###########################################

function copydir(){

ls -lr $dir > $backupdir/directory-info.last

}

###########################################

function comptxt(){

if  cmp -s $backupdir/directory-info.new $backupdir/directory-info.last

then

	echo " no change so no backup"

	

else	if [ $backupcounter -gt 0 ] 

	then	echo " out comp"

		date=$(date '+%Y-%m-%d-%H-%M-%S')

		arr+=($date)

		mkdir -p $backupdir/$date

		cp -r $dir $backupdir'/'$date

		copydir

		backupcounter=`expr $backupcounter - 1`

	else 

	        echo "max backup times reached"

	        delete=${arr[0]}

	        unset arr[0]

	        echo ${arr[@]}

	        rm -r $backupdir/$delete

	        backupcounter= backupcounter=`expr $backupcounter + 1`

	        comptxt

	fi	

	

fi

}

###########################################

function backup(){

ls -lr $dir > $backupdir/directory-info.last

while :

do

	sleep $sleeptime

	ls -lr $dir > $backupdir/directory-info.new

	comptxt

	

done

}

###########################################

if [ -d "$dir" ]

then

	echo "source exists "

	if [ -d "$backupdir" ]

	then

		echo "copy directory already exists "

		cp -r $dir $backupdir'/'$date

	        backupcounter=`expr $backupcounter - 1`

	        arr=($date)

		echo ${arr[@]}

	        backup

	        

	else 

	        

		echo "copy directory doesnt exist i will create it"

		mkdir -p $backupdir'/'$date

		cp -r $dir $backupdir'/'$date

		backupcounter=`expr $backupcounter - 1`

		arr=($date)

		echo ${arr[@]}

		backup

	fi      

		

else 

	echo "source directory doesnt exist"

	

fi

	  



