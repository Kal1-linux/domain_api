#!/bin/bash

# NGINX configuration file path
NGINX_CONFIG_PATH="/etc/nginx/sites-enabled/default"

# Extract domains using grep and awk, clean up using tr, sed, and sort
domains=$(grep -E "server_name[[:space:]]" "$NGINX_CONFIG_PATH" | awk '{for (i=2; i<=NF; i++) print $i}' | tr -d ';' | tr -s ',' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -s ' ' | sed 's/ /,/g')

# Filter out domains containing numerical values
filtered_domains=$(echo "$domains" | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

# Remove repeated domains
unique_domains=$(echo "$filtered_domains" | tr ',' '\n' | sort -u | paste -sd, -)

# Print the list of unique server names
echo "Unique Server Names in $NGINX_CONFIG_PATH:"
echo "$unique_domains" > /domains.txt

