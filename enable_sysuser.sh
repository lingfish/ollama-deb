#!/bin/bash

RULES_FILE="debian/rules"

# Check if `--with sysuser` is already present
if ! grep -q -- "--with sysuser" "$RULES_FILE"; then
    # Insert `--with sysuser` in the debhelper sequence
    echo "Adding --with sysuser to $RULES_FILE..."
    sed -i 's/dh \$@/dh $@ --with sysuser/' "$RULES_FILE"
else
    echo "--with sysuser is already enabled in $RULES_FILE."
fi

