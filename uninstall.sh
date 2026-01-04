#!/bin/bash

# Claude Warp uninstaller

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"

echo "Uninstalling claude-warp..."

rm -f "$BINDIR/claude-warp"

echo "✓ Uninstalled successfully!"
