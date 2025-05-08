#!/bin/bash

# Function to check if WordPress is ready
wait_for_wordpress() {
    echo "Waiting for WordPress service to be ready..."
    
    for i in $(seq 1 15); do
        if nc -z wordpress 9000 &>/dev/null; then
            echo "WordPress service is ready!"
            return 0
        fi
        echo "Attempt $i/15: WordPress not ready yet, waiting..."
        sleep 2
    done
    
    echo "Failed to connect to WordPress after 15 attempts"
    return 1
}

# Wait for WordPress to be ready
wait_for_wordpress

echo "Nginx setup complete, starting server..."

# Execute the command passed to the script
exec "$@"
