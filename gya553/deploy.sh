#!/bin/bash

# Deploy script for GYA553 function scripts

DEST_DIR="/Applications/Ethos Suite.app/Contents/.simulator/1.6.3/persist/X20PROAW/scripts"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"
mkdir -p "$DEST_DIR/gya553-status"
mkdir -p "$DEST_DIR/gya553-gains"

# Delete old compiled versions
rm -f "$DEST_DIR/gya553-gains/main.luac"
rm -f "$DEST_DIR/gya553-status/main.luac"

# Copy the new combined script
cp -r gya553-status/* "$DEST_DIR/gya553-status/"
cp -r gya553-gains/* "$DEST_DIR/gya553-gains/"

echo "Deployed GYA553 scripts to simulator/scripts"
