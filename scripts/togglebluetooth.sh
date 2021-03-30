# Toggles bluetooth
if bluetoothctl show | grep Powered | grep yes > /dev/null; then
    bluetoothctl power off
else
    bluetoothctl power on
    bluetoothctl connect EC:81:93:6D:6A:2B
fi
