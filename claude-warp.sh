#!/bin/bash

# Claude Warp - Fast model switching for Claude Code
# Quick switch when you run out of quota

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"
PORT=8080

# Colors
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
C='\033[0;36m'
N='\033[0m'

# Clean exit on Ctrl+C
trap 'echo -e "\n${Y}Bye!${N}"; exit 0' INT TERM

# Ensure settings file exists
ensure_settings() {
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    [[ -f "$SETTINGS_FILE" ]] || echo '{}' > "$SETTINGS_FILE"
}

# Get current status
status() {
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        echo -e "${G}Native Claude API${N}"
        return
    fi

    local url=$(jq -r '.env.ANTHROPIC_BASE_URL // empty' "$SETTINGS_FILE" 2>/dev/null)
    local model=$(jq -r '.env.ANTHROPIC_MODEL // empty' "$SETTINGS_FILE" 2>/dev/null)

    if [[ -z "$url" || "$url" == "null" ]]; then
        echo -e "${G}● Native Claude API${N}"
    else
        echo -e "${C}● Proxy Mode${N} → ${Y}$model${N}"
    fi
}

# Switch to native
native() {
    ensure_settings
    local tmp=$(jq 'del(.env.ANTHROPIC_BASE_URL, .env.ANTHROPIC_AUTH_TOKEN, .env.ANTHROPIC_MODEL) |
                    if .env == {} then del(.env) else . end' "$SETTINGS_FILE")
    echo "$tmp" > "$SETTINGS_FILE"
    echo -e "${G}✓ Switched to Native Claude API${N}"
}

# Switch to proxy model
proxy() {
    local model=$1
    ensure_settings
    local tmp=$(jq --arg m "$model" --arg p "$PORT" '
        .env.ANTHROPIC_AUTH_TOKEN = "test" |
        .env.ANTHROPIC_BASE_URL = "http://localhost:\($p)" |
        .env.ANTHROPIC_MODEL = $m
    ' "$SETTINGS_FILE")
    echo "$tmp" > "$SETTINGS_FILE"
    echo -e "${C}✓ Switched to${N} ${Y}$model${N}"
}

# Start proxy
start() {
    if lsof -i :$PORT &>/dev/null; then
        echo -e "${Y}Proxy already running on :$PORT${N}"
        return
    fi
    echo -e "${C}Starting proxy on :$PORT...${N}"
    if command -v osascript &>/dev/null; then
        osascript -e "tell application \"Terminal\" to do script \"npx antigravity-claude-proxy start --port $PORT\""
        echo -e "${G}✓ Proxy started in new Terminal${N}"
    else
        nohup npx antigravity-claude-proxy start --port $PORT > /tmp/cw-proxy.log 2>&1 &
        echo -e "${G}✓ Proxy started (log: /tmp/cw-proxy.log)${N}"
    fi
}

# Stop proxy
stop() {
    if lsof -i :$PORT &>/dev/null; then
        kill $(lsof -t -i :$PORT) 2>/dev/null
        echo -e "${G}✓ Proxy stopped${N}"
    else
        echo -e "${Y}No proxy running on :$PORT${N}"
    fi
}

# Account management shortcuts
accounts() {
    case "$1" in
        add|a)  npx antigravity-claude-proxy accounts add ;;
        list|l) npx antigravity-claude-proxy accounts list ;;
        verify|v) npx antigravity-claude-proxy accounts verify ;;
        *) npx antigravity-claude-proxy accounts list ;;
    esac
}

# Help
help() {
    echo "Claude Warp - Fast model switching"
    echo ""
    echo "Usage: cw [command]"
    echo ""
    echo "Switch Models:"
    echo "  n, native     Native Claude API (restore)"
    echo "  s, sonnet     Claude Sonnet 4.5 (thinking)"
    echo "  o, opus       Claude Opus 4.5 (thinking)"
    echo "  c, claude     Claude Sonnet 4.5 (no thinking)"
    echo "  g, gemini     Gemini 3 Flash"
    echo "  gp            Gemini 3 Pro (high)"
    echo ""
    echo "Proxy Control:"
    echo "  start         Start proxy server"
    echo "  stop          Stop proxy server"
    echo ""
    echo "Accounts:"
    echo "  acc [add|list|verify]"
    echo ""
    echo "No args = show current status"
}

# Main
case "${1:-}" in
    "")           status ;;
    n|native)     native ;;
    s|sonnet)     proxy "claude-sonnet-4-5-thinking" ;;
    o|opus)       proxy "claude-opus-4-5-thinking" ;;
    c|claude)     proxy "claude-sonnet-4-5" ;;
    g|gemini)     proxy "gemini-3-flash" ;;
    gp)           proxy "gemini-3-pro-high" ;;
    gl)           proxy "gemini-3-pro-low" ;;
    start)        start ;;
    stop)         stop ;;
    acc|accounts) accounts "$2" ;;
    h|help|-h|--help) help ;;
    *)
        echo -e "${R}Unknown: $1${N}"
        help
        exit 1
        ;;
esac
