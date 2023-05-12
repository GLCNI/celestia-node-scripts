# UI for PayForBlob Transactions
This uses some parts of the PayForBlob auto scripts in the parent folder to create a easy user interface for manually submitting PFB transactions with button interactions or setting a automated PFB Tx routine to run in the background.

this application is for use with `multi-client` deployment scripts, though it is for use with `celestia-node` (data availability – light or full-storage) other install methods might require some manual configuration.

## How to Install
### 1. Install Script 
Easiest way to run the UI, no setup required. Requires Celestia-node installed and running, full storage or light node, and funded with enough gas for submitting PFB Txs.

**pfb-ui script functions**

- select API interface (`Gateway API` or `RPC API` )

- downloads all dependancies to run the UI (`python3` `pip` `flask` )

- downloads all files needed to run UI

- downloads binary for generating either hex or base64 encoded random data

**Download script**
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/GUI/pfb-ui.sh && chmod a+x pfb-ui.sh
```

**Run Script**
```
./pfb-ui.sh
```
Select API Method (gateway or RPC API), script will download all files for the UI based on API method, then check and download dependancies 

**Open in browser** 
`http://<public-IP>:5000`
close the terminal session to exit application `ctrl + c`

### 2. Install Manually  

**Requirements**

**celestia- node installed, full storage or light init (see `multi-client` directory)**
```
https://github.com/GLCNI/celestia-node-scripts/tree/main/multi-network
```

**Packages required**
```
#check python version ( Ubuntu 20.04 LTS comes with Python 3.8.5 pre-installed)
python version
# install pip
sudo apt install python3-pip -y
# install flask
pip3 install Flask
```

**Open Port** 
```
sudo ufw allow 5000
```

**Download files**
to $HOME directory
for Gateway API: `gateway-pfb-ui`
for RPC API: `rpc-pfb-ui`

**Start flask application**
```
cd gateway-pfb-ui
python3 app.py
```

**Open in browser**
`http://<public-IP>:5000`
