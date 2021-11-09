#!/bin/bash
tmp1="/mnt/tmp2/"
prefix="/home/gg/vfarm2-"
totalDisk=2
count=1
dn1="$prefix$count/1843/"

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

#dn1="$prefix$count/"

if [ ! -x "$dn1" ]; then
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
   	   if [ -f "$FILE" ]
	   then
		#判断目标文件是否存在，若存在并且文件
                echo "current plot is $FILE"
                filename=${FILE#*$tmp1}
                echo $filename
                dstfile=$dn1$filename
                if [ -f "$dstfile" ]
                then
                        echo $dstfile

                        checkfilesize $FILE $dstfile
                fi


		space=$(df $dn1 --output=avail | grep -E '^[0-9]')
		space=$(($space / 1024 / 1024))
		echo "current working dir is $dn1, $space G left"
		if [ $space -lt 102 ]
		then
		#开始移动
			echo "$dn1 deosn't have enough space,skipping ..."
			count=$(($count + 1))
			if [ $count -gt $totalDisk ]
			then
				count=$(($count - $totalDisk))
			fi
			dn1="$prefix$count/"
			echo "switch to $dn1"
			sleep 5s
		else
			
			#开始移动
			
			echo $FILE
			echo "*************************"
			echo "Start moving to Desination Drive$dn1, "`date '+%Y%m%d-%H:%M'`
			echo "*************************" 
			mv -v $FILE $dn1
			echo "*************************" 
			echo "Finished moving to Desination Drive$dn1, "`date '+%Y%m%d-%H:%M'`	
			echo "*************************" 
		fi

	   else
		echo "*************************"
		echo "current working dir is $dn1, $space G left"
		echo "Waiting for plots....."
		echo "*************************"
		sleep 180s
	   fi



	fi
done
	##echo `find $dn1 -type f ! -name "*.plot" |wc -l "Plots in" $dn1`
done
