#!/bin/bash

sudo apt update && sudo apt upgrade -y	

#install pre-reqs
apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y

#install go to tmp directory and download go binary.
cd /tmp && wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz 

#unzip to install to /usr/local
tar -C /usr/local/ -xzf go1.19.1.linux-amd64.tar.gz 

#to set GOPATH and GOROOT for bash terminal.
cd /usr/local/ && echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc && echo "export GOROOT=/usr/local/go" >> ~/.bashrc && echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> /home//.bashrc && echo "export GOROOT=/usr/local/go" >> /home//.bashrc && source ~/.bashrc && source /home/*/.bashrc 	

#Installed Go 'source ~/.bashrc' will not run inside sh
#celestia build and run is performed in script 2- celestia-light-2.sh

echo "Finshed installing required packages and go, To continue run the following commands"
echo "source ~/.bashrc"
echo "now test go version"
