#!/bin/sh
set -e

# Capture runtime UID/GID from environment variables, defaulting to 1000
PUID=${USER_UID:-1000}
PGID=${USER_GID:-1000}

# Adjust the node user's UID/GID if they differ from the runtime request
# and fix volume ownership only when a remap is needed
changed=0

if [ "$(id -u node)" -ne "$PUID" ]; then
    echo "Updating node UID to $PUID"
    usermod -o -u "$PUID" node
    changed=1
fi

if [ "$(id -g node)" -ne "$PGID" ]; then
    echo "Updating node GID to $PGID"
    groupmod -o -g "$PGID" node
    usermod -g "$PGID" node
    changed=1
fi

if [ "$changed" = "1" ]; then
    chown -R node:node /paperclip
fi

# Ensure config directory exists and is owned by node
mkdir -p /paperclip/instances/default
chown -R node:node /paperclip

# Define the CLI invoker with the correct loader for production resolution (e.g. zod)
CLI_CMD="node --import ./server/node_modules/tsx/dist/loader.mjs ./cli/src/index.ts"

# Auto-onboard and bootstrap if this is a fresh setup
if [ ! -f "/paperclip/instances/default/config.json" ]; then
    echo "First run detected: Configuring default paperclip instance..."
    gosu node $CLI_CMD onboard -y
    echo "Generating Bootstrap CEO Invite Link:"
    gosu node $CLI_CMD auth bootstrap-ceo
fi

exec gosu node "$@"
