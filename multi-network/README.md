# Celestia Node deployment scripts- multi-network

Deployment scripts for Celestia DA Nodes: this includes Full storage node and light nodes. Currently supporting Mocha, blockspacerace and Arabica networks.

shell scripts to automate the installation and configuration for a Celestia Light client or Full storage Node.

**Script performs following tasks:**
• Installs Pre-requisite packages
• Installs Go
• Select Celestia Network (mocha/blockspacerace/arabica)
• Installs Celestia node
• Initiate Celestia Node for light client / full storage
• Setup wallet or import existing
• Setup and start light client with systemD

**Hardware Requirements-Light:** CPU: Single Core/ 2GB RAM/ Disk: 5 GB SSD/ 56Kbps Download/upload This is incredibly lightweight requirements that you can even run on a Mobile phone with ARM based CPU/Linux based OS

**Hardware Requirements-Full Storage:** CPU: Quad-Core / 8 GB RAM/ Disk: 1 TB SSD Storage/ 1 Gbps for Download/ Upload

---------------------------------------------------------------------------------------------
## Light Nodes

### Install: Ubuntu

Works on any Ubuntu OS 20:04LTS-22.04 device

Manual steps: [Celestia Light Node - Mocha](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/ulStKYpvi1RHFWO0fuqUmM4-Ch_qUcIR8Bunbn-Gpaw)

  
**Download and make executable**
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/light-node.sh && chmod a+x light-node.sh
``` 

**Run script install**
```
./light-node.sh
```

### Install: ARM based devices (Rpi-4 / Pinephone )

Tested on: raspberry pi model 4b using Ubuntu for ARM, Pinephone running Mobian (debian based mobile OS)

Very similar to normal Ubuntu install the main difference being go ARM version is required and how some updates and dependencies are handled.  

Note that getting run on will likely require additional setup related to device itself, for more detail see.

Ex using Pinephone (with Mobian): [Light Node on Mobile - Mocha](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/4UHV59sD23M2yeuLk17ukvJUzmgNo1pcnqQEcKsIkvM)

Ex Using Raspberry Pi 4b (with Ubuntu): [Light Node Raspberry Pi - Mocha](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/1IneKgzcoy7L-uTuSYzWPMkWo45jaBxX7XdryaiG3hk)

**Download and make executable**
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/light-node-ARM.sh && chmod a+x light-node-ARM.sh
``` 

**Run script install**
```
./light-node-ARM.sh
```

### Install: Arch Linux

A minimal extremely lightweight Linux distribution, becoming popular around gaming using Linux.

Tested on SteamDeck (runs Arch Linux) this is beta, not fully tested on other arch Linux based devices, likely require a lot more configuration steps related to system itself, more detail in this example: [celestia node on mobile devices](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/1cB-lOAWzGKgGvItDXzwyMUnkR1PC3sIKEfa5yIPM8k)

**Download and make executable**
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/light-node-arch.sh && chmod a+x light-node-arch.sh
``` 

**Run script install**
```
./light-node-arch.sh
```

---------------------------------------------------------------------------------------------
## Full Storage Node

### Install: Ubuntu 

This is a shell script which automates the installation and configuration for a Celestia Full Storage node. For Ubuntu 20.04 LTS-22.04

Manual Steps:  
[Celestia Full Storage Node- Blockspace race](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/dIDJPGAkFeAdC98bojKn-4oHpRb5e7w0QAHTCKcsgRU)  
[Celestia Full Storage Node - Mocha](https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/Tc7O6Kzw2RoDmA_FWT1O3HUAkcY69tnIQ8QhAokkTk4)

**Download and make executable**
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/full-storage-node.sh && chmod a+x full-storage-node.sh
``` 

**Run script install**
```
./full-storage-node.sh
```

---------------------------------------------------------------------------------------------
## PayForBlob with Celestia Node

Full storage and light nodes can be used to PayForBlob (pay for data) to be stored on the Celestia data availability layer.

**See the `payforblob` folder for** **tools**

- How to Submit PFBs with celestia node
- Easy UI for submitting PFBs  
- Tool for automating PFBs at regular intervals

---------------------------------------------------------------------------------------------
## Monitoring Celestia Node

Tools for monitoring of Celestia node

**See `monitoring` folder for more detail**

- Using `SNMP` for hardware metrics  
- Using `Grafana` and `Prometheus` for monitoring DA nodes
- More detail in folder such as monitoring hardware for multiple nodes, system alerts for downtime, DA performance capture
