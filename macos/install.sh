#!/usr/bin/env bash
set -euo pipefail

say_step() {
    printf "\n\033[36m== %s ==\033[0m\n" "$1"
}

has() {
    command -v "$1" >/dev/null 2>&1
}

install_brew_formula() {
    FORMULA=$1
    NAME=$2
    CHECK_COMMAND=$3

    if has "$CHECK_COMMAND"; then
        echo "$NAME 이미 설치되어 있습니다. 건너뜁니다."
    else
        if brew install "$FORMULA" >/dev/null 2>&1; then
            echo "$NAME 설치 완료"
        else
            echo "$NAME 설치 중 문제가 발생했습니다. 나중에 다시 시도해주세요."
        fi
    fi
}

install_vscode() {
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        echo "Visual Studio Code 이미 설치되어 있습니다. 건너뜁니다."
    else
        if brew install --cask visual-studio-code >/dev/null 2>&1; then
            echo "Visual Studio Code 설치 완료"
        else
            echo "Visual Studio Code 설치 중 문제가 발생했습니다. 나중에 다시 시도해주세요."
        fi
    fi
}

install_npm() {
    PACKAGE=$1
    NAME=$2
    COMMAND=$3

    if has "$COMMAND"; then
        echo "$NAME 이미 설치되어 있습니다. 건너뜁니다."
    else
        if npm install --global "$PACKAGE" >/dev/null 2>&1; then
            echo "$NAME 설치 완료"
        else
            echo "$NAME 설치 중 문제가 발생했습니다. 네트워크 상태를 확인한 뒤 다시 시도해주세요."
        fi
    fi
}

say_step "CLI Installer 설치"

# Homebrew 설치
if ! has brew; then
    say_step "Homebrew 설치"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon
    if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Intel Mac
    if [ -x "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if ! has brew; then
        echo "Homebrew 설치를 확인할 수 없습니다. 터미널을 새로 열어 다시 실행해주세요."
        exit 1
    fi
fi

say_step "기본 개발환경 설치"
install_brew_formula node "Node.js" node
install_brew_formula python "Python" python3
install_brew_formula git "Git" git
install_vscode

if ! has npm; then
    echo "npm을 찾을 수 없습니다. 터미널을 새로 열어 다시 실행해주세요."
    exit 1
fi

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
