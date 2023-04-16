# How to submit PayForBlob transactions 

**What is pay for blob**

*A type of transaction, submitting a payload of arbitrary bytes (like a serialized block), paying for the amount of block space that the submitted data takes up.*

**Check node balance**

This will be the wallet imported or generated for node, wallet will need to have enough funds to cover fees.
```
curl -X GET http://127.0.0.1:26659/balance
```
**1.	Generate name space and data values**

for testing a go playground here can be used to create random data in suitable format: https://go.dev/play/p/7ltvaj8lhRl 

Alternatively a `datagenerator` binary can be downloaded from the script in `/datagenerator` . to create `namespace_id` and `data` values in either hex encoded or base64 data. 

For Gateway API use hex encoded data

For RPC API use base64 encoded data

**2.	Submit pay for blob (PFB)**

**Using Gateway API**

Example using generated data: from `/datagenerator`
```
curl -X POST -d '{"namespace_id": "0be6685be4ad1a1f",
  "data": " 387565daf6d60239f441a0910cc2fb073f00f3112e9f88ef8b3a9d52a45939df2b11eb93ab83ff030c92d8cb797ffc9ef17a",
  "gas_limit": 80000, "fee": 2000}' http://localhost:26659/submit_pfb
```
Expected output: from submit PFB will have in the first two lines

example:
```
"height": 251745,
  "txhash": " 2E17D81B5FD28640B5683EEF3C3FA6120CE7AAA43A0C8E83BF73A857EF7C1A58",
```

**Using RPC API**

```
celestia rpc state SubmitPayForBlob <namespace_ID> <data> 2000 100000
```

**3.	Confirm - Return Output and get shares**

Search the txhash in the blockexplorer to confirm transaction, to get shares by namespace -

**Using Gateway API**
```
curl -X GET \
  http://localhost:26659/namespaced_shares/0be6685be4ad1a1f/height/251745
```

**Using RPC API**
```
curl -X GET \
  http://localhost:26659/namespaced_shares/<namespace_ID>/height/<height>
```

# Run Script to automate PFB transactions

Run a script to auto generate random data and submit PFB transactions at a selected time interval, transaction data is logged. This works for light nodes or full storage nodes setup via the `multi-client` node deployment scripts.

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

**Using RPC API**: use `payforblob-auto-rpc.sh`

*NOTE: RPC API script uses a base64 encoded datagenerator*

1.	Download script
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/payforblob/payforblob-auto-rpc.sh
```
2.	Make executable
```
chmod a+x payforblob-auto-rpc.sh
```
Run script
```
./payforblob-auto-rpc.sh
```


