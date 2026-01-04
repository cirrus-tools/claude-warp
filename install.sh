#!/bin/bash

# Claude Warp installer

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"

echo "Installing claude-warp to $BINDIR..."

# Check dependencies
missing=()
command -v jq &>/dev/null || missing+=("jq")
command -v npx &>/dev/null || missing+=("node")

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Warning: Missing dependencies: ${missing[*]}"
    echo "Install with: brew install ${missing[*]}"
fi

# Install
install -d "$BINDIR"
install -m 755 bin/claude-warp "$BINDIR/claude-warp"

echo ""
echo "✓ Installed successfully!"
echo ""
echo "Usage: claude-warp [command]"
echo "  claude-warp        Show current status"
echo "  claude-warp s      Switch to Sonnet"
echo "  claude-warp o      Switch to Opus"
echo "  claude-warp n      Switch to Native API"
echo ""
echo "Run 'claude-warp help' for all commands."
