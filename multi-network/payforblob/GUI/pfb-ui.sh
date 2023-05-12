#!/bin/bash

# select API type
echo "Select API type for submitting PFBs:"
echo "1. Gateway API"
echo "2. RPC API"
read -p "Enter your choice (1 or 2): " choice

# DOWNLOAD FILES FOR RPC SELECTION
if [ "$choice" == "2" ]; then
    # create directories
    mkdir rpc-pfb-ui
    cd rpc-pfb-ui
    mkdir -p templates
    mkdir -p static/images
    # download files
    wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/rpc-pfb-ui/rpc.sh
    wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/rpc-pfb-ui/app.py
    wget -P templates https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/rpc-pfb-ui/templates/index.html
    wget -P static/images https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/2bdfdbffb0a25b4a7dbd90fa7be01614a03f669e/multi-network/payforblob/GUI/rpc-pfb-ui/static/images/image-2-resize-400x400.png
    cd ..
fi

# DOWNLOAD FILES FOR GATEWAY SELECTION
if [ "$choice" == "1" ]; then
    # create directories
    mkdir gateway-pfb-ui
    cd gateway-pfb-ui
    mkdir -p templates
    mkdir -p static/images
    # download files
    wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/gateway-pfb-ui/gateway.sh
    wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/gateway-pfb-ui/app.py
    wget -P templates https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/gateway-pfb-ui/templates/index.html
    wget -P static/images https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/2bdfdbffb0a25b4a7dbd90fa7be01614a03f669e/multi-network/payforblob/GUI/gateway-pfb-ui/static/images/image-1-resize-400x400.png
    cd ..
fi

# check if python3 is installed, if not then install
if ! command -v python3 &> /dev/null
then
    echo "Python 3 could not be found. Attempting to install..."
    sudo apt-get update
    sudo apt-get install python3.8
fi

# install pip
echo "Checking and installing pip..."
sudo apt-get install python3-pip

# install flask
echo "Installing Flask..."
pip3 install flask

#open port 5000
sudo ufw allow 5000
sudo ufw allow ssh
sudo ufw enable

# start the UI 
if [ "$choice" == "2" ]; then
    echo "Starting RPC UI..."
    cd rpc-pfb-ui
    python3 app.py
elif [ "$choice" == "1" ]; then
    echo "Starting Gateway UI..."
    cd gateway-pfb-ui
    python3 app.py
fi
