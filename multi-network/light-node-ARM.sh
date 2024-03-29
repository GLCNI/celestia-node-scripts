#!/bin/bash

# Check if .bash_profile exists
if [ ! -f ~/.bash_profile ]; then
    # If not, check if .profile exists
    if [ -f ~/.profile ]; then
        # If .profile exists, rename it to .bash_profile
        mv ~/.profile ~/.bash_profile
    else
        # If neither file exists, create .bash_profile
        touch ~/.bash_profile
    fi
fi

#install pre-reqs
sudo apt update 
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

#install go ver1.20.1 for ARM sh
wget "https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/go/go-v1.20.3-ARM-install.sh"
chmod a+x go-v1.20.3-ARM-install.sh
./go-v1.20.3-ARM-install.sh

source ~/.bash_profile

# confirm install
if command -v go &> /dev/null; then
    echo "Go is installed and the PATH is set up correctly"
    go version
else
    echo "Go is not installed or the PATH is not set up correctly"
fi

#NETWORK SELECTION
echo -n "select network (1 - mocha testnet, 2 - blockspacerace, 3 - arabica devnet) > "
read selectnetwork
echo
if test "$selectnetwork" == "1"
then
    NETWORK="mocha"
    echo "export NETWORK=$NETWORK" >> $HOME/.bash_profile
    source $HOME/.bash_profile
fi
if test "$selectnetwork" == "2"
then
    NETWORK="blockspacerace"
    echo "export NETWORK=$NETWORK" >> $HOME/.bash_profile
    source $HOME/.bash_profile
fi
if test "$selectnetwork" == "3"
then
    NETWORK="arabica"
    echo "export NETWORK=$NETWORK" >> $HOME/.bash_profile
    source $HOME/.bash_profile
fi

#INSTALL CELESTIA NODE
#version based on network selection
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/

#select version tag based on network
if [ "$NETWORK" == "mocha" ]
then
    CELESTIA_VER="v0.6.4"
elif [ "$NETWORK" == "blockspacerace" ]
then
    CELESTIA_VER="v0.10.0"
elif [ "$NETWORK" == "arabica" ]
then
    CELESTIA_VER="v0.7.1"
fi

echo "export CELESTIA_VER=$CELESTIA_VER" >> $HOME/.bash_profile
source $HOME/.bash_profile

#checkout appropriate version and build Celestia
git checkout tags/$CELESTIA_VER
make build 
sudo make install				
make cel-key

#INITIALISE AS LIGHT NODE
celestia light init --p2p.network $NETWORK

#SETUP VARIABLES
source $HOME/.bash_profile

#select gRPC endpoint use default or enter custom
if [ "$NETWORK" == "mocha" ]
then
    GRPC_PROMPT="select gRPC endpoint (1 - default-https://rpc-mocha.pops.one, 2 - enter custom gRPC) > "
    DEFAULT_URL="https://rpc-mocha.pops.one"
fi

if [ "$NETWORK" == "blockspacerace" ]
then
    GRPC_PROMPT="select gRPC endpoint (1 - default-https://rpc-blockspacerace.pops.one/, 2 - enter custom gRPC) > "
    DEFAULT_URL="https://rpc-blockspacerace.pops.one"
fi

if [ "$NETWORK" == "arabica" ]
then
    GRPC_PROMPT="select gRPC endpoint (1 - default-https://limani.celestia-devops.dev, 2 - enter custom gRPC) > "
    DEFAULT_URL="https://limani.celestia-devops.dev"
fi

echo -n "$GRPC_PROMPT"
read selectendpoint
echo
if test "$selectendpoint" == "1"
then
    RPC_ENDPOINT="$DEFAULT_URL"
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bash_profile
fi
if test "$selectendpoint" == "2"
then
    read -p "Enter Your Endpoint: " RPC_ENDPOINT
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bash_profile
fi

#WALLET SETUP
#use default wallet or import existing
source $HOME/.bash_profile
echo -n "import existing wallet? (1 - use auto-generated wallet, 2 - import existing wallet) > "
read selectwallet
echo
if test "$selectwallet" == "1"
then
    WALLET="my_celes_key"
    echo "export WALLET=$WALLET" >> $HOME/.bash_profile
fi
if test "$selectwallet" == "2"
then
    read -p "Enter name for wallet: " WALLET
    echo "export WALLET=$WALLET" >> $HOME/.bash_profile
fi

#display wallet info or import existing
if [ "$WALLET" == "my_celes_key" ]
then
    ./cel-key list --node.type light --p2p.network $NETWORK --keyring-backend test
    echo "to pay for data transactions this address must be funded, press any key to continue"
    read -n 1 -r -s -p ""
else
    ./cel-key add $WALLET --keyring-backend test --node.type light --p2p.network $NETWORK --recover
fi

#SETUP SYSTEM SERVICE 
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-light.service
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which celestia) light start --keyring.accname $WALLET --p2p.network $NETWORK --core.ip $RPC_ENDPOINT --gateway --gateway.addr localhost 
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
