# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Warp is a bash CLI tool for quickly switching Claude Code between native Anthropic API and proxy models (via antigravity-claude-proxy) when quota runs out.

## Architecture

Single bash script (`bin/claude-warp`) that modifies `~/.claude/settings.json` to switch between:
- **Native mode**: Direct Anthropic API
- **Proxy mode**: Routes through localhost proxy with alternative models

Key functions:
- `proxy()` / `native()` - Core switching logic via jq manipulation of settings.json
- `menu()` / `accounts_menu()` / `proxy_menu()` - Interactive menus using bash `select`
- `start()` / `stop()` - Proxy server control via lsof/kill

## Development Commands

```bash
# Test the script directly
./bin/claude-warp help
./bin/claude-warp status

# Install locally
./install.sh

# Uninstall
./uninstall.sh
```

## Dependencies

- `jq` - Required for JSON manipulation
- `node` - Required for npx to run antigravity-claude-proxy

## Distribution

Distributed via Homebrew tap at `cirrus-tools/homebrew-tap`. Formula located at `../homebrew-tap/Formula/claude-warp.rb`.

To release:
1. Tag version: `git tag v0.x.x && git push origin v0.x.x`
2. Calculate sha256: `curl -sL <tarball-url> | shasum -a 256`
3. Update formula sha256 in homebrew-tap repo
