
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Large Request Payloads in Apache HTTP.
---

This incident type refers to situations where the Apache HTTP server receives unusually large request payloads from clients. A request payload is the data that a client sends to the server as part of a request. When the payload is too large, it can cause various issues such as performance degradation, timeouts, and even server crashes. These incidents can affect the availability and reliability of the server, and they need to be addressed promptly to prevent further impact on the system.

### Parameters
```shell
export APACHE_PORT="PLACEHOLDER"

export NETWORK_INTERFACE="PLACEHOLDER"

export VIRTUAL_HOST_CONFIG_FILE="PLACEHOLDER"

export APACHE_CONFIG_FILE_PATH="PLACEHOLDER"

export MAXIMUM_PAYLOAD_SIZE="PLACEHOLDER"
```

## Debug

### Check if Apache is running
```shell
systemctl status apache2
```

### Check Apache error logs for any related error
```shell
tail -n 50 /var/log/apache2/error.log
```

### Check the size of incoming HTTP requests
```shell
tcpdump -i ${NETWORK_INTERFACE} port ${APACHE_PORT} -s 0 -A 'tcp[(tcp[12]>>4)*4]=0x47455420' | grep "Content-Length"
```

### Check the Apache configuration file for the maximum allowed request size
```shell
cat /etc/apache2/apache2.conf | grep "LimitRequestBody"
```

### Check the Apache virtual host configuration file for the maximum allowed request size
```shell
cat /etc/apache2/sites-available/${VIRTUAL_HOST_CONFIG_FILE} | grep "LimitRequestBody"
```

### Check the Apache HTTP headers for any information about the request
```shell
curl -I http://localhost:${APACHE_PORT}
```

### Check the Apache access logs for the incoming request details
```shell
tail -n 50 /var/log/apache2/access.log
```

## Repair

### Increase the maximum allowed size for request payloads in the Apache settings.
```shell

#!/bin/bash

# Set the maximum allowed size for request payloads

${APACHE_CONFIG_FILE_PATH}=/etc/httpd/conf/httpd.conf

${MAXIMUM_PAYLOAD_SIZE}="10MB"

# Backup the original Apache config file

cp ${APACHE_CONFIG_FILE_PATH} ${APACHE_CONFIG_FILE_PATH}.bak

# Update the Apache config file with the new maximum payload size

sed -i 's/^\(LimitRequestBody\s*\).*/\1${MAXIMUM_PAYLOAD_SIZE}/' ${APACHE_CONFIG_FILE_PATH}


# Restart Apache to apply the changes

service httpd restart


```