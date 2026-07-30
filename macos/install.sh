#!/usr/bin/env bash
set -euo pipefail

say_step() {
    printf "\n\033[36m== %s ==\033[0m\n" "$1"
}

has() {
    command -v "$1" >/dev/null 2>&1
}

install_npm() {
    PACKAGE=$1
    NAME=$2
    COMMAND=$3

    if has "$COMMAND"; then
        echo "Skip $NAME already installed."
    else
        npm install --global "$PACKAGE"
        echo "$NAME installed."
    fi
}

say_step "CLI Installer 설치"

# Homebrew 설치
if ! has brew; then
    say_step "Homebrew 설치"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Intel Mac
if [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

say_step "기본 개발환경 설치"
brew install node python git
brew install --cask visual-studio-code

echo ""
echo "설치할 AI CLI를 선택하세요."
echo ""
echo "[1] Claude Code"
echo "[2] OpenAI Codex"
echo "[3] Gemini CLI"
echo "[4] 전체 설치"
echo ""
read -p "선택 (예: 1,2): " choice

selected=()

IFS=',' read -ra choices <<< "$choice"
for item in "${choices[@]}"; do
    item="$(echo "$item" | xargs)"
    case "$item" in
        1) selected+=("claude") ;;
        2) selected+=("codex") ;;
        3) selected+=("gemini") ;;
        4) selected=("claude" "codex" "gemini"); break ;;
    esac
done

if [ ${#selected[@]} -eq 0 ]; then
    echo "잘못된 선택입니다."
    exit 1
fi

for tool in "${selected[@]}"; do
    case $tool in
        claude)
            install_npm "@anthropic-ai/claude-code" "Claude Code" "claude"
            ;;
        codex)
            install_npm "@openai/codex" "OpenAI Codex" "codex"
            ;;
        gemini)
            install_npm "@google/gemini-cli" "Gemini CLI" "gemini"
            ;;
    esac
done

echo ""
echo "설치 완료!"
echo ""
echo "사용 가능한 명령어:"
for tool in "${selected[@]}"; do
    echo " $tool"
done
