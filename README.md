# Configuration of Route 53 should be required to be done

# Installation of node and mysql required to run this

# configure .env file should be there

# commnds to run

npm i
npm i pm2 -g
pm2 start server.js


# curl to send post request to test your site is running!

curl -X POST -H "Content-Type: application/json" -d '{"domain": "{YOUR-DOMAIN}"}' http://{YOUR-IP}:3002/add-domain

