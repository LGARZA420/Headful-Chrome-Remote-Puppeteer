#!/bin/bash

# Function to find an available display number
find_available_display() {
    local display_number=0
    while [ $display_number -le 10 ]; do
        if [ ! -f /tmp/.X$display_number-lock ]; then
            echo $display_number
            return
        fi
        display_number=$((display_number + 1))
    done
    echo "No available display number found." >&2
    exit 1
}

# Clean up leftover lock files
cleanup_lock_files() {
    echo "Cleaning up leftover lock files..."
    rm -f /tmp/.X*-lock
}

# Find an available display number
cleanup_lock_files
DISPLAY_NUMBER=$(find_available_display)
export DISPLAY=:$DISPLAY_NUMBER

echo "Starting X server on display $DISPLAY"

# Start Xvfb on the available display
Xvfb $DISPLAY -screen 0 1024x768x24 &

# Start x11vnc
x11vnc -display $DISPLAY -usepw -forever -quiet &

# Start Node.js application
node --inspect=0.0.0.0:9229 index.js --remote-debugging-port=9222 &

# Wait for the Node.js server to start
sleep 5

# Check if the debugging endpoint is available
echo "Checking /json/version endpoint..."
curl -s http://localhost:9222/json/version

# Start Nginx in the foreground
echo "starting Nginx"
nginx -g 'daemon off;'

# Keep the script running
wait#!/bin/bash

# Function to find an available display number
find_available_display() {
    local display_number=0
    while [ $display_number -le 10 ]; do
        if [ ! -f /tmp/.X$display_number-lock ]; then
            echo $display_number
            return
        fi
        display_number=$((display_number + 1))
    done
    echo "No available display number found." >&2
    exit 1
}

# Clean up leftover lock files
cleanup_lock_files() {
    echo "Cleaning up leftover lock files..."
    rm -f /tmp/.X*-lock
}

# Find an available display number
cleanup_lock_files
DISPLAY_NUMBER=$(find_available_display)
export DISPLAY=:$DISPLAY_NUMBER

echo "Starting X server on display $DISPLAY"

# Start Xvfb (virtual framebuffer)
Xvfb :1 -screen 0 1280x800x24 &

# Start Nginx for reverse proxying the Chrome DevTools
nginx &

# Start VNC server, listening on port 5900
x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -forever -shared -rfbport 5900 &

# Start noVNC, listening on port 6080, and proxying to the VNC server
/usr/local/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080 &

# Start Node.js application
node --inspect=0.0.0.0:9229 index.js --remote-debugging-port=9222 &

# Wait for the Node.js server to start
sleep 5

# Check if the debugging endpoint is available
echo "Checking /json/version endpoint..."
curl -s http://localhost:9222/json/version

# Start Nginx in the foreground
echo "starting Nginx"
nginx -g 'daemon off;'

# Keep the script running
wait
