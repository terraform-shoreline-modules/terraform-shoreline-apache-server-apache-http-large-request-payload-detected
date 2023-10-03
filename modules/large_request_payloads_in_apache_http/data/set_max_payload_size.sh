
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