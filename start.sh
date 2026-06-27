#!/bin/bash

# Add ngrok auth token
ngrok config add-authtoken $NGROK_TOKEN

# Start xrdp service
service xrdp start

echo "======================================="
echo "xrdp started. Launching ngrok tunnel..."
echo "======================================="

# Start ngrok TCP tunnel in background
ngrok tcp 3389 --log=stdout &

# Wait for ngrok to start
sleep 8

# Print the public RDP address
curl -s http://localhost:4040/api/tunnels | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for t in data['tunnels']:
        addr = t['public_url'].replace('tcp://', '')
        print('=======================================')
        print('YOUR RDP ADDRESS IS:')
        print(addr)
        print('Username: rdpuser')
        print('Password: MyPassword123')
        print('=======================================')
except:
    print('Tunnel not ready yet - check logs in 1 min')
"

# Keep container alive
tail -f /dev/null
