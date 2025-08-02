#!/bin/bash

# Generate secure secrets
export FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
export REDIS_PASS=$(openssl rand -hex 24)

# Create .env file
cat > .env <<EOF
FERNET_KEY=$FERNET_KEY
REDIS_PASS=$REDIS_PASS
EOF

# Build and start containers
docker-compose up -d --build

# Get onion address
sleep 10  # Wait for Tor to initialize
ONION_ADDR=$(docker-compose exec tor cat /var/lib/tor/hidden_service/hostname)

echo "================================================"
echo " PhantomPay Deployment Complete"
echo "================================================"
echo " Onion Service: http://${ONION_ADDR}"
echo " Web Interface: http://$(curl -s ifconfig.me):3000"
echo "================================================"
echo " Important: Store these credentials securely:"
echo " - Fernet Key: $FERNET_KEY"
echo " - Redis Pass: $REDIS_PASS"
echo "================================================"