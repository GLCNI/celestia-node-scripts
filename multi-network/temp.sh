#!/bin/bash

#del existing
sudo rm /etc/systemd/system/celestia-light.service

#SETUP SYSTEM SERVICE 
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-light.service
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --keyring.accname my_celes_key --p2p.network mocha --core.ip https://rpc-mocha.pops.one --gateway --gateway.addr localhost 
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

#start the service
sudo systemctl daemon-reload
sudo systemctl enable celestia-light
sudo systemctl start celestia-light

#display logs 
echo "celestia light node is now setup and running"
echo "you can display logs at any time with "journalctl -u celestia-light.service -f""
echo -n "press y to display logs on the terminal (otherwise press enter ) > "
read displaylogs
echo
if test "$displaylogs" == "y"
then
    journalctl -u celestia-light.service -f
fi
