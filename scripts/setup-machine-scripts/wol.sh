nic=`ip -o -4 route show to default | awk '{print $5}'`

echo Starting WOL for interface: $nic

service="[Unit]\n\n
Description=Configure Wake On LAN\n
\n
[Service]\n
Type=oneshot\n
ExecStart=/sbin/ethtool -s "$nic" wol g\n
\n
[Install]\n
WantedBy=basic.target\n
"
sudo touch /etc/systemd/system/wol.server
sudo echo $service > /etc/systemd/system/wol.service
systemctl daemon-reload
systemctl enable wol.service
systemctl start wol.service
logout
