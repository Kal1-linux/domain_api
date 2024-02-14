#!/bin/bash

# NGINX configuration file path
#NGINX_CONFIG_PATH="/etc/nginx/sites-enabled/default"

# Extract domains using grep and awk, clean up using tr, sed, and sort
#domains=$(grep -E "server_name[[:space:]]" "$NGINX_CONFIG_PATH" | awk '{for (i=2; i<=NF; i++) print $i}' | tr -d ';' | tr -s ',' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -s ' ' | sed 's/ /,/g')

# Filter out domains containing numerical values
#filtered_domains=$(echo "$domains" | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

# Remove repeated domains
#unique_domains=$(echo "$filtered_domains" | tr ',' '\n' | sort -u | paste -sd, -)

# Print the list of unique server names
#echo "Unique Server Names in $NGINX_CONFIG_PATH:"
#echo "$unique_domains" > /domains.txt

######

#!/bin/bash

# NGINX configuration directory path
NGINX_CONFIG_DIR="/etc/nginx/sites-enabled/"

# Extract domains from all configuration files using grep, awk, and tr
server_names=$(grep -hE "server_name[[:space:]]" "$NGINX_CONFIG_DIR"/* | awk '{for (i=2; i<=NF; i++) print $i}' | tr -d ';' | tr -s ',' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -s ' ' | sed 's/ /,/g')

# Filter out any non-domain entries
filtered_server_names=$(echo "$server_names" | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

# Remove repeated server names
unique_server_names=$(echo "$filtered_server_names" | tr ',' '\n' | sort -u | paste -sd, -)

# Remove curly braces and commas from the end
cleaned_server_names=$(echo "$unique_server_names" | sed 's/[{},]*$//')

# Remove leading comma before the first domain
cleaned_server_names=$(echo "$cleaned_server_names" | awk -F, '{if (NR==1) sub(/,/, ""); print}')

# Remove occurrences of "server_name" from the list
cleaned_server_names=$(echo "$cleaned_server_names" | sed 's/server_name,//g')

# Print the cleaned list of unique server names
echo "$cleaned_server_names" > /domains.txt
