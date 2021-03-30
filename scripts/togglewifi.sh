out=`nmcli radio wifi`
if [[ "$out" == "enabled" ]]; then
    nmcli radio wifi off
    echo Wifi disabled
else
    nmcli radio wifi on
    echo Wifi enabled
fi

