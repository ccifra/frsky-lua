#!/bin/bash

# Deploy script for GYA553 function scripts

DEST_DIR="/Applications/Ethos Suite.app/Contents/.simulator/1.6.3/persist/X20PROAW/scripts"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"
mkdir -p "$DEST_DIR/gya553-status"

# Delete old compiled versions
rm -f "$DEST_DIR/gya553-gains.luac"
rm -f "$DEST_DIR/gya553-status/main.luac"

# Copy the new combined script
cp gya553-gains.lua "$DEST_DIR/"
cp -r gya553-status/* "$DEST_DIR/gya553-status/"

echo "Deployed GYA553 scripts to simulator/scripts"
