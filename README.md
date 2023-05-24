# celestia-node-scripts
deployment scripts for celestia nodes

-------------------------------------------------------------------------------------------------------------------

## THIS FOLDER IS NO LONGER SUPPORTED
**for up to date deployment scripts see 'multi-network'**

**'multi-network' adds more functionality and support for multiple testnets, including long term testnet 'Mocha'**

-------------------------------------------------------------------------------------------------------------------

# Celestia Light Node – Ubuntu/ARM
This is a shell script which automates the installation and configuration for a Celestia Light client on Mocha Testnet. For Ubuntu 20.04 LTS or ARM based distro such as Debian 
This script performs following tasks:
-	Installs Pre-requisite packages 
-	Installs Go
-	Installs Celestia node 
-	Initiate Celestia Node for light client
-	Setup and start light client with systemD

Hardware Requirements: CPU: Single Core/ 2GB RAM/ Disk: 5 GB SSD/ 56Kbps Download/upload
This is incredibly lightweight requirements that you can even run on a Mobile phone

script automates the setup found in 

Ubuntu:  https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/ulStKYpvi1RHFWO0fuqUmM4-Ch_qUcIR8Bunbn-Gpaw

Mobile ARM: https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/4UHV59sD23M2yeuLk17ukvJUzmgNo1pcnqQEcKsIkvM

Celestia Official docs: https://docs.celestia.org/

You can follow the mirror articles to do it manually, the script is intended to reduce the steps to deploy and get many more light clients set up on various devices.

Light clients perform Data Availability Sampling (DAS) which enables Celestia to scale the DA layer. since each light node only samples a small portion of the block data, more light nodes the more data the network can collectively download and store.

## Steps to run script - Ubuntu

log in as root user \
`sudo -i`

download script \
`wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/light-node/cel-light-1.sh` \
or download directly from this repository

make executable \
`chmod a+x cel-light-1.sh`

Run script \
`./cel-light-1.sh`

Respond to the prompts on screen, once first part is completed run \
`source ~/.bashrc`
`./cel-light-2.sh`

select gRPC endpoint either default or input your own

## Steps to run script - ARM

depending on device and OS distribution, setup might not be compatible and there may be extra difficulties. For example testing with mobian OS on pinephone x64 device you must ssh into the device to perform root commands to avoid being locked out of the GUI while running the script. More details in the article for setup on mobile.

enable ssh
`sudo apt-get install openssh-server`
`sudo systemctl enable ssh`

log in as root user \
`sudo -i`

download script \
`wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/light-node-ARM/cel-light-arm.sh` 

make executable \
`chmod a+x cel-light-arm.sh`

Run script \
`./cel-light-arm.sh`

Respond to the prompts on screen, once first part is completed run \
`source ~/.bashrc`
`./cel-light-2.sh`

select gRPC endpoint either default or input your own

# Celestia Full Storage Node
This is a shell script which automates the installation and configuration for a Celestia Full Storage client on Mocha Testnet. For Ubuntu 20.04 LTS.

This script performs following tasks:
- Installs Pre-requisite packages
- Installs Go
- Installs Celestia node
- Initiate Celestia Node for full storage client
- Setup and start full storage client with systemD

script automates the setup found in
https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/Tc7O6Kzw2RoDmA_FWT1O3HUAkcY69tnIQ8QhAokkTk4 

Celestia Official docs: https://docs.celestia.org/ https://docs.celestia.org/nodes/full-storage-node 

## Steps to run script

log in as root user \
`sudo -i`

download script \
`wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/full-storage-node/cel-full-storage-1.sh` \
or download directly from this repository

make executable \
`chmod a+x cel-full-storage-1.sh`

Run script \
`./cel-full-storage-1.sh`

Respond to the prompts on screen, once first part is completed run \
`source ~/.bashrc`
`./cel-full-storage-2.sh`

select gRPC endpoint either default or input your own
