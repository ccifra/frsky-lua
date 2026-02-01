#!/bin/bash

# Deploy GYA553Status widget to Ethos Suite simulator

SOURCE="/Users/christopher.cifra/dev/LuaScripts/GYA553Status/main.lua"
DEST="/Applications/Ethos Suite.app/Contents/.simulator/1.6.3/persist/X20PROAW/scripts/GYA553Status"

# Create destination directory if it doesn't exist
mkdir -p "$DEST"

# Delete compiled version if it exists
rm -f "$DEST/main.luac"

# Copy the script
cp "$SOURCE" "$DEST/main.lua"

echo "✓ Deployed GYA553Status widget to simulator (removed .luac)"
