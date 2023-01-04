#!/bin/bash

#install celestia node
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.6.1
make install				
make cel-key

#initialise as full storage
celestia full init

#select gRPC endpoint use default or enter custom
echo -n "select gRPC endpoint (1 - default-https://grpc-mocha.pops.one:9090, 2 - enter custom gRPC,default - no) > "
read selectendpoint
echo
if test "$selectendpoint" == "1"
then
    RPC_ENDPOINT=$"https://grpc-mocha.pops.one:9090"
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bashrc
fi
if test "$selectendpoint" == "2"
then
    read -p "Enter Your Endpoint: " RPC_ENDPOINT
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bashrc
fi

#create system service
echo "[Unit]
Description=celestia-full Cosmos daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia full start --core.ip $RPC_ENDPOINT
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target" > $HOME/celestia-full.service
sudo mv $HOME/celestia-full.service /etc/systemd/system/

#enable and start service
systemctl enable celestia-full
systemctl start celestia-full

# show default address created on init
echo "This is your addresss"
./cel-key show my_celes_key --node.type full --keyring-backend test -a
echo "In order to PayForData Transactions you will need to fund this address"

#logs
echo "you can display logs at any time with "journalctl -u celestia-full.service -f""
echo -n "press y to display logs on the terminal (otherwise press enter ) > "
read displaylogs
echo
if test "$displaylogs" == "y"
then
    journalctl -u celestia-full.service -f
fi
