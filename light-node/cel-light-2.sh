#!/bin/bash

#install celestia node
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.6.0
make install				
make cel-key

#init node
celestia light init

#select gRPC endpoint use default or enter custom
echo -n "select gRPC endpoint (1 - default-https://rpc-mocha.pops.one:9090, 2 - enter custom gRPC,default - no) > "
read selectendpoint
echo
if test "$selectendpoint" == "1"
then
    RPC_ENDPOINT=$"https://rpc-mocha.pops.one:9090"
    echo RPC_ENDPOINT=$RPC_ENDPOINT | sudo tee -i -a /root/.celestia-light-mocha/config.toml
fi
if test "$selectendpoint" == "2"
then
    read -p "Enter Your Endpoint: " RPC_ENDPOINT
    echo RPC_ENDPOINT=$RPC_ENDPOINT | sudo tee -i -a /root/.celestia-light-mocha/config.toml
fi

#create system service
echo "[Unit]
Description=celestia-lightd Light Node
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia light start --core.ip $RPC_ENDPOINT 
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target" > $HOME/celestia-lightd.service
sudo mv $HOME/celestia-lightd.service /etc/systemd/system/

#enable and start service
sudo systemctl enable celestia-lightd
sudo systemctl start celestia-lightd

#display wallet 
cd celestia-node
echo "your wallet address is below, to pay for data transactions you will need to fund this address"
echo "(cat ./cel-key list --node.type light --keyring-backend test)"

#logs
echo "you can display logs at any time with"
echo "sudo journalctl -u celestia-lightd.service -f"
echo -n "press y to display logs on the terminal (otherwise press enter ) > "
read displaylogs
echo
if test "$displaylogs" == "y"
then
    sudo journalctl -u celestia-lightd.service -f
fi
