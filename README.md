# Claude Warp

Fast model switching for Claude Code - quickly switch to proxy models when your quota runs out.

## Installation

```bash
# Homebrew
brew tap cirrus-tools/tap
brew install claude-warp

# Manual
./install.sh
```

## Dependencies

- `gum` - Interactive UI
- `jq` - JSON processing
- `node` - For npx to run antigravity-claude-proxy

```bash
brew install gum jq node
npm install -g antigravity-claude-proxy
```

## Usage

```bash
claude-warp              # Interactive menu
claude-warp status       # Show current status

# Quick switch (CLI)
claude-warp s            # Claude Sonnet 4.5 (thinking)
claude-warp o            # Claude Opus 4.5 (thinking)
claude-warp c            # Claude Sonnet 4.5 (no thinking)
claude-warp g            # Gemini 3 Flash
claude-warp gp           # Gemini 3 Pro (high)
claude-warp gl           # Gemini 3 Pro (low)
claude-warp n            # Native Claude API (restore)

# Proxy control
claude-warp start        # Start proxy server
claude-warp stop         # Stop proxy server

# Account management
claude-warp acc          # Interactive account manager
claude-warp acc add      # Add Google account (OAuth)
claude-warp acc list     # List all accounts
claude-warp acc verify   # Verify all accounts
claude-warp acc limits   # Check quota limits
```

### Interactive Menu

Running `claude-warp` without arguments shows an interactive menu:

```
Claude Warp - Current: Native Claude API

> sonnet      → Claude Sonnet 4.5 (thinking)
  opus        → Claude Opus 4.5 (thinking)
  claude      → Claude Sonnet 4.5 (no thinking)
  gemini      → Gemini 3 Flash
  gemini-pro  → Gemini 3 Pro (high)
  native      → Native Claude API
  accounts    → Manage Google accounts
  proxy       → Start/Stop proxy server
  quit

Select:
```

Running `claude-warp acc` opens the account manager:

```
Account Manager

> list    → Show all accounts
  add     → Add new Google account (OAuth)
  verify  → Verify all accounts
  limits  → Check quota limits
  back

Select action:
```

## How It Works

This tool modifies `~/.claude/settings.json` to switch Claude Code between:
- **Native mode**: Direct Anthropic API (your normal quota)
- **Proxy mode**: Routes through [antigravity-claude-proxy](https://github.com/badri-s2001/antigravity-claude-proxy) to use alternative models

---

## Safety, Usage, and Risk Notices

### Intended Use

- Personal / internal development only
- Quick switching when Claude Code quota is exhausted
- Not for production services or bypassing intended limits

### Not Suitable For

- Production application traffic
- High-volume automated extraction
- Any use that violates Acceptable Use Policies

### Warning (Assumption of Risk)

By using this software, you acknowledge and accept the following:

**Terms of Service risk**: This approach may violate the Terms of Service of AI model providers (Anthropic, Google, etc.). You are solely responsible for ensuring compliance with all applicable terms and policies.

**Account risk**: Providers may detect this usage pattern and take punitive action, including suspension, permanent ban, or loss of access to paid subscriptions.

**No guarantees**: Providers may change APIs, authentication, or policies at any time, which can break this method without notice.

**Assumption of risk**: You assume all legal, financial, and technical risks. The authors and contributors of this project bear no responsibility for any consequences arising from your use.

**Use at your own risk. Proceed only if you understand and accept these risks.**

---

## License

MIT
