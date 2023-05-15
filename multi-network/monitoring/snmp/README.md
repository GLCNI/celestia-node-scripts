# Monitoring with SNMP and PRTG 

This setup uses SNMP installed on Linux devices for monitoring and sending information to PRTG monitoring software on a separate dedicated device.

SNMP: (Simple Network Management Protocol) is a remote probe, which is going to be deployed to monitor Linux devices. SNMP is a widely used protocol designed for managing devices on IP networks. 

PTRG: a powerful easy-to-use network monitoring software developed by Paessler AG for windows, PTRG is not open source and is free for up to 100 sensors, but It offers a wide range of monitoring options, such as SNMP.

## Setup monitoring server 

### setup snmp monitoring probe on target device 
**Install snmp**
```
sudo apt update
sudo apt install snmpd snmp libsnmp-dev
```

**Edit configuration** 
```
#backup the default configuration file:
sudo cp /etc/snmp/snmpd.conf{,.bak}
#Edit configuration file
sudo nano /etc/snmp/snmpd.conf
```
In the config file, bind IP (should device to monitor/snmp installed) local or public to port 161
```
master agentx
agentaddress  127.0.0.1,[::1]
agentaddress udp:<local-IP>:161
```
Make public `rocommunity`, remove other arguments 
```
#read-only access to everyone on the systemonly view
rocommunity public
rocommunity6 public
```

**Restart the service**

```
sudo systemctl daemon-reload
sudo systemctl restart snmpd
```

**Firewall**

`snmp` exposes devices on port `161`, this must be opened

## Setup PTRG on dedicated device 

**Download PTRG to windows device** 

paessler.com/ptrg/download

this is a network monitor that scans all available sensors on the target device compatible with snmp, and you can pick and select what you want to monitor: Put on a windows server PC that is always on.

**Setup account**

Once installed, it opens a browser
Default login: prtgadmin : prtgadmin

**Scan for available sensors**

Devices > will look for all available devices on the local area network

Select and ‘recommend sensors’ to find everything available on the device

![image](https://user-images.githubusercontent.com/67609618/236052729-c6f2da2e-3606-4b0f-a34a-8a6b763ef3d5.png)


# Monitor System service with PRTG 

custom sensor for PRTG to monitor liveness of celestia-node service, can be used with full storage or light nodes.  

**To Install:**

Save to /usr/local/bin/ on the target device 
```
wget https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/monitoring/snmp/service-monitor.sh
```
Note: do not need to run this, as PRTG will do this

On PRTG Monitoring server:
Navagate to device (should be already connected with SNMP steps before) > add sensor > SSH Script

Configure Sensor:
1. Enter the script name and location on device 
2. Credentials for Linux Systems: Ensure you provide valid credentials for the target Ubuntu system.
3. Parameters: Leave this blank as our script doesn't need any parameters.
4. Sensor Result: Choose "Exit code" as sensor result, sensor status will be determined by the exit code of the script.
