dir=$(pwd)
cd

folders=".backup .cache .config pictures work snap .aws downloads .bash_history .vim .kde .gtkrc-2.0"
filename=$dir/$(date +%d-%m-%y)-backup.tar.gz

echo $filename

sudo tar --use-compress-program="pigz -k -1" -cf $filename $folders

cd $dir
