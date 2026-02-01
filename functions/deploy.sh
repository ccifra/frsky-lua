#!/bin/bash

# Deploy script for GYA553 function scripts

DEST_DIR="/Applications/Ethos Suite.app/Contents/.simulator/1.6.3/persist/X20PROAW/scripts"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Delete old compiled versions
rm -f "$DEST_DIR/gya553HHGain.luac"
rm -f "$DEST_DIR/gya553Ngain.luac"
rm -f "$DEST_DIR/gya553Gains.luac"

# Copy the new combined script
cp gya553Gains.lua "$DEST_DIR/"

echo "Deployed GYA553 gain script to simulator/scripts"
