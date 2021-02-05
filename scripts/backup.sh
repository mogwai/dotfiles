dir=$(pwd)
cd

folders=".config pictures .vim snap desktop .aws downloads .bash_history .vim .kde .gtkrc-2.0 .aws"
filename=$dir/$(date +%d-%m-%y)-backup.tar.gz

echo $filename

sudo tar --use-compress-program="pigz -k -1" -cf $filename $folders

cd $dir
