# CLI Installer - AI Developer Setup

새 Windows 또는 macOS 컴퓨터에서 AI 코딩 환경을 빠르게 준비하기 위한 설치 도구입니다.

터미널이 익숙하지 않은 사용자도 한 줄 명령으로 Git, Node.js와 AI CLI 개발 도구를 설치할 수 있도록 구성했습니다.

지원하는 AI CLI:

- Claude Code
- OpenAI Codex
- Gemini CLI

설치 과정에서 원하는 도구를 직접 선택할 수 있습니다.

---

# 🙏 참고 및 출처 (Credits)

이 프로젝트는 아래 오픈소스 프로젝트를 참고하여 제작되었습니다.

## Windows 설치 구조 참고

https://github.com/jikime/oneshot-installer-for-window

Windows 환경에서 개발 도구를 자동 설치하는 흐름과 설치 스크립트 구조를 참고했습니다.

## macOS 설치 구조 참고

https://github.com/jikime/oneshot-installer-for-mac

macOS 환경에서 Homebrew 기반으로 개발 환경을 구성하는 방식을 참고했습니다.

원본 프로젝트를 공유해주신 앤써니(Anthony Kim / jikime)께 감사드립니다.

본 프로젝트는 위 프로젝트의 아이디어와 구조를 참고하여 Claude Code, OpenAI Codex, Gemini CLI를 하나의 설치 과정으로 구성하고 Windows와 macOS 환경에서 쉽게 사용할 수 있도록 확장한 프로젝트입니다.

---

# Windows 설치

## 처음 설치하기

1. Windows 키를 누르고 PowerShell을 실행합니다.

2. 아래 명령어를 붙여넣고 실행합니다.

```powershell
irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1 | iex
