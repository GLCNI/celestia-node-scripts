# How to submit PayForBlob transactions 

# Run Script to automate PFB transactions

Run a script to auto generate random data and submit PFB transactions at a selected time interval, transaction data is logged. 

## What the script does

-	Check node status (celestia-node installed/ node type/ network/ wallet & balance)
-	Download and build random ‘datagenerator’
-	Run datagenerator and submit PFB transaction  
-	Input time interval for PFB transactions
-	Submits PFB TXs at interval
-	Stores data (TX hash/ block height/ namespace shares) to log file 

## Steps to run
**Using gateway API**: use `payforblob-auto-gateway.sh`

*NOTE: gateway API will soon be deprecated. celestia-node exposes its REST gateway on port 26659 by default.* 

1.	Download script 
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/payforblob-auto-gateway.sh
```
2.	Make executable 
```
chmod a+x payforblob-auto-gateway.sh
```
3.	Run script
```
./payforblob-auto-gateway.sh
```

**Using RPC API**: (pending)
