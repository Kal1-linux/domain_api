#certbot --nginx --agree-tos -m laoo@gmail.com --non-interactive --domains --expand
certbot --nginx --agree-tos -m laoo@gmail.com --non-interactive --domains $(cat /domains.txt) --expand
