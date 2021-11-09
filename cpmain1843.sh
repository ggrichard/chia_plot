#!/bin/bash
tmp1="/mnt/tmp1/"
tmp2="/home/gg/ramdisk1/"
farmer_key="a80d870d82031b51eeafa9237a9f2879f6e5578a3b62a41a713de1603d0231149a6a35f6582ab3cded5c8115523ecdcf"
pool_key="b26f8e6facc1803422a3d68f7a76a25a71e1ff1a50d581dc7f5c80c4c15574348bb592b0c252ab870cac9dbf32e0fda5"
plot_number=10000
threads=20
buckets=7
./chia-plotter/build/chia_plot -n $plot_number -p $pool_key -f $farmer_key -t $tmp1 -2 $tmp2 -r $threads -u $buckets tee -a plot$LogNameDATE.log
echo "All $plot_number plots finished"
