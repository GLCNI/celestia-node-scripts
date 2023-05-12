#!/bin/bash

# CHECK CURRENT NODE STATUS
# check celestia node installed if not, exit the script
if [ ! -d "$HOME/celestia-node" ]; then
    echo "You need celestia-node installed and a data availability node running to submit PayForBlob TXs in this script"
    exit 1
fi
# check node type
if [ -f "/etc/systemd/system/celestia-full.service" ]; then
  NODETYPE="full"
elif [ -f "/etc/systemd/system/celestia-light.service" ]; then
  NODETYPE="light"
else
  echo "Neither celestia-full.service nor celestia-light.service exists in /etc/systemd/system/ are you sure you are running a DA node?"
  exit 1
fi
echo "export NODETYPE=$NODETYPE" >> $HOME/.bash_profile
source $HOME/.bash_profile
# get balance
balance=$(curl -sX GET http://127.0.0.1:26659/balance | jq -r '.amount')
export balance=$balance
# get wallet
cd $HOME/celestia-node
./cel-key list --node.type $NODETYPE --p2p.network $NETWORK --keyring-backend test
echo "you are running a $NODETYPE node on $NETWORK network, ensure the address above is sufficiently funded to PayForBlob TXs the current balance of this address is $balance utia"
sleep 10
cd

# BUILD DATA GENERATOR 
# downloads and builds a random hex encoded data generator based on go
# check datagenerator exists if it exists skip the download and build 
if [ ! -d "$HOME/datagenerator" ]; then
  # Download the file
  wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/datagenerator/datagenerator-base64.sh

  # Grant permissions to the script
  chmod +x datagenerator-base64.sh

  # Run the script
  ./datagenerator-base64.sh

  # Load Environment Variables
  source $HOME/.bash_profile
fi
# this sub-script downloads a random base64 encoded data generator based on go, creates an binary executable file to be called anytime to create random data for payforblob txs

# Load Environment Variables
source $HOME/.bash_profile

cat << 'EOF' > pfb-repeater.sh
#!/bin/bash

# RUN DATA GENERATOR and store values
output=$(datagenerator)
# Store the first line into a variable
TEMP_NAMESPACE_ID=$(echo "$output" | sed -n 1p)
# store the second line into a variable
TEMP_DATA=$(echo "$output" | sed -n 2p)
# SUBMIT PFD TX
# save output and store the height as variable & store the tx hash as variable
export CELESTIA_NODE_AUTH_TOKEN=$(celestia "$NODETYPE" auth admin --p2p.network "$NETWORK")
response=$(celestia rpc state SubmitPayForBlob "$TEMP_NAMESPACE_ID" "$TEMP_DATA" 2000 100000)
TEMP_HEIGHT=$(echo "$response" | jq -r '.result.height')
TEMP_TXHASH=$(echo "$response" | jq -r '.result.txhash')
# Append the variables to a log file
echo "$(date) - Namespace ID: $TEMP_NAMESPACE_ID, Data: $TEMP_DATA, Height: $TEMP_HEIGHT, Tx Hash: $TEMP_TXHASH" >> $HOME/datagenerator/logfile.log
EOF

# Make pfb-repeater.sh executable
chmod +x pfb-repeater.sh
