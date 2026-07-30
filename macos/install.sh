#!/usr/bin/env bash

set -euo pipefail


say_step() {
  printf "\n\033[36m== %s ==\033[0m\n" "$1"
}


has() {
  command -v "$1" >/dev/null 2>&1
}


install_npm() {

  local package="$1"
  local name="$2"
  local command="$3"


  if has "$command"; then
    printf "  Skip %s already installed.\n" "$name"
    return
  fi


  npm install --global "$package"

  printf "  OK %s installed.\n" "$name"

}


select_tools() {

echo ""

echo "설치할 AI CLI를 선택하세요."

echo ""

echo "[1] Claude Code"
echo "[2] OpenAI Codex"
echo "[3] Gemini CLI"
echo "[4] 전체 설치"

echo ""

read -p "선택 (1-4): " choice


case "$choice" in

1)
  selected=("claude")
  ;;

2)
  selected=("codex")
  ;;

3)
  selected=("gemini")
  ;;

4)
  selected=("claude" "codex" "gemini")
  ;;

*)
  echo "잘못된 선택입니다."
  select_tools
  ;;

esac

}



if ! has brew; then

say_step "Installing Homebrew"

 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi



if ! has brew && [ -x /opt/homebrew/bin/brew ]; then

eval "$(/opt/homebrew/bin/brew shellenv)"

elif ! has brew && [ -x /usr/local/bin/brew ]; then

eval "$(/usr/local/bin/brew shellenv)"

fi



has brew || {

echo "Homebrew 설치 실패"

exit 1

}



say_step "Installing base developer tools"


brew install node python git


brew install --cask visual-studio-code



select_tools



for tool in "${selected[@]}"; do


case "$tool" in


claude)

install_npm \
"@anthropic-ai/claude-code" \
"Claude Code" \
"claude"

;;


codex)

install_npm \
"@openai/codex" \
"OpenAI Codex" \
"codex"

;;


gemini)

install_npm \
"@google/gemini-cli" \
"Gemini CLI" \
"gemini"

;;


esac


done



printf "\n설치 완료\n"

printf "사용 가능 명령어:\n"

printf " claude\n"

printf " codex\n"

printf " gemini\n"
