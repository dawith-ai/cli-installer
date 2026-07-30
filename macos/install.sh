#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-essential}"
TOOLS="${2:-}"

say_step() { printf '\n\033[36m%s\033[0m\n' "$1"; }
has() { command -v "$1" >/dev/null 2>&1; }
install_npm() {
  local package="$1" name="$2" command="$3"
  if has "$command"; then printf '  Skip  %s is already installed.\n' "$name"; return; fi
  npm install --global "$package"
  printf '  OK    %s installed.\n' "$name"
}

if ! has brew; then
  say_step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew is /opt/homebrew on Apple Silicon and /usr/local on Intel Macs.
# Load it in this shell as well, so the remaining commands work right away.
if ! has brew && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif ! has brew && [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
has brew || { echo "Homebrew could not be started. Open a new Terminal window and run this script again."; exit 1; }

say_step "Installing base developer tools"
brew install node python git
brew install --cask visual-studio-code

case "$PROFILE" in
  essential) selected=(claude codex) ;;
  all) selected=(claude codex gemini) ;;
  custom)
    [ -n "$TOOLS" ] || { echo "For custom: ./install.sh custom claude,codex"; exit 2; }
    IFS=',' read -r -a selected <<< "$TOOLS"
    ;;
  *) echo "Usage: ./install.sh [essential|all|custom] [claude,codex,gemini]"; exit 2 ;;
esac

for tool in "${selected[@]}"; do
  case "$tool" in
    claude) install_npm '@anthropic-ai/claude-code' 'Claude Code' 'claude' ;;
    codex) install_npm '@openai/codex' 'OpenAI Codex' 'codex' ;;
    gemini) install_npm '@google/gemini-cli' 'Gemini CLI' 'gemini' ;;
    *) echo "Unsupported tool: $tool"; exit 2 ;;
  esac
done

printf '\nDone. Start with: codex, claude, or gemini\n'
