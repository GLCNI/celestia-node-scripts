# Multi-Network Celestia Node Install scripts

deployment scripts for celestia nodes, suitable for all networks (test-networks)

---------------
## Celestia Light Node - Ubuntu/ARM

This is a shell script which automates the installation and configuration for a Celestia Light client. 
For Ubuntu 20.04 LTS or ARM based distro such as Debian 

This script performs following tasks:
•	Installs Pre-requisite packages
•	Installs Go
•	Select Celestia Network (mocha/blockspacerace/arabica)
•	Installs Celestia node
•	Initiate Celestia Node for light client
•	Setup wallet or import existing
•	Setup and start light client with systemD

**Hardware Requirements:** CPU: Single Core/ 2GB RAM/ Disk: 5 GB SSD/ 56Kbps Download/upload This is incredibly lightweight requirements that you can even run on a Mobile phone with ARM based CPU/linux based OS 

### Steps to Run Script - Ubuntu 
download script, or download directly from this repository
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/light-node.sh
```

make executable
```
chmod a+x light-node.sh
```
Run script
```
./light-node.sh
```
Respond to Prompts on terminal

### Steps to run script – ARM 

download script
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/light-node-ARM-sh
```
make executable
```
chmod a+x light-node-ARM.sh
```
Run script
```
./light-node-ARM.sh
```
Respond to Prompts on terminal

--------------------------------------------------------------------------------------------------------------------
## Celestia Full Storage Node – Ubuntu

This is a shell script which automates the installation and configuration for a Celestia Full Storage node. 
For Ubuntu 20.04 LTS.

This script performs following tasks:
•	Installs Pre-requisite packages
•	Installs Go
•	Select Celestia Network (mocha/blockspacerace/arabica)
•	Installs Celestia node
•	Initiate Celestia Node for full storage
•	Setup wallet or import existing
•	Setup and start full storage node with systemD

### Steps to run script – Ubuntu
download script
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/full-storage-node.sh
```

make executable
```
chmod a+x full-storage-node.sh
```
Run script
```
./full-storage-node.sh
```
Respond to Prompts on terminal

--------------------------------------------------------------------------------------------------------------------
