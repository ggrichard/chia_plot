#!/bin/bash
tmp1="/mnt/tmp2/"
prefix="/home/gg/vfarm2-"
totalDisk=2
count=1
dn1="$prefix$count/1662/"
dn2="$prefix$count/1056/"

function checkfilesize() {

        filesize1=`ls -l $1 | awk '{ print $5}'`
        filesize2=`ls -l $2 | awk '{ print $5}'`
        #plotsize=$((108*1024*1024*1024))
        
        echo "plot in tmp is $1, filesize is $filesize1"
        echo "plot in dst is $2, filesize is $filesize2"

        if [ $filesize2 -lt  $filesize1 ]
        then
                echo "removing $2"
                rm $2
        else
                echo "removing $1"
                rm $1
        fi
}




while true
do

for FILE in $tmp1*.plot
do

if [ ! -d "$dn1" ]; then
        echo "$dn1 not available, please check"
        count=$(($count + 1))
        if [ $count -gt $totalDisk ]
        then
                count=$(($count - $totalDisk))
        fi
        dn1="$prefix$count/"
        echo "switch to $dn1"
        sleep 60s

else


	if [ -f "$FILE" ];then

		echo "current plot is $FILE"
                filename=${FILE#*$tmp1}
                echo $filename


		lastfile=`ls -1 $dn2*.plot |tail -1`

		echo "last file is $lastfile"

		if [ -f "$lastfile" ];then
			
			rm $lastfile
			
			#开始移动
			
			echo $FILE
			echo "******************************************************************************************************************************************************************************************************************************************************"
			echo "Start moving to Desination Drive$dn1, "`date '+%Y%m%d-%H:%M'`
			echo "******************************************************************************************************************************************************************************************************************************************************"
 
			mv -v $FILE $dn1
			echo "******************************************************************************************************************************************************************************************************************************************************"
			echo "*************************" 
			echo "Finished moving to Desination Drive$dn1, "`date '+%Y%m%d-%H:%M'`	
			echo "*************************"
			echo "******************************************************************************************************************************************************************************************************************************************************"
		else
			echo "no file left in$dn2 ,switch disk"
			count=$(($count + 1))
			if [ $count -gt $totalDisk ]
			then
				count=$(($count - $totalDisk))
			fi
			dn1="$prefix$count/"
			echo "switch to $dn1"
			sleep 60s

		fi
	

	else
	echo "*************************"
	echo "current working dir is $dn1, $space left"
	echo "Waiting for plots....."
	echo "*************************"
	sleep 180s
	fi
fi


done
done
