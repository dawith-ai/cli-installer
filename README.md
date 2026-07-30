# CLI Installer - AI Developer Setup

새 Windows 또는 macOS 환경에서 AI 코딩 개발 환경을 빠르게 구성하는 설치 도구입니다.

터미널 사용이 익숙하지 않은 사용자도 한 줄 명령으로 개발 환경을 준비할 수 있도록 만들었습니다.

지원 AI CLI:

- Claude Code
- OpenAI Codex
- Gemini CLI


---

# 🙏 Credits

이 프로젝트는 아래 오픈소스 프로젝트를 참고하여 제작되었습니다.


## Windows 참고

https://github.com/jikime/oneshot-installer-for-window


Windows 환경에서 개발 도구 자동 설치 방식과 설치 흐름을 참고했습니다.


## macOS 참고

https://github.com/jikime/oneshot-installer-for-mac


macOS 환경에서 Homebrew 기반 개발 환경 구성 방식을 참고했습니다.


원본 프로젝트를 공유해주신
앤써니(Anthony Kim / jikime)께 감사드립니다.


본 프로젝트는 위 프로젝트의 구조와 아이디어를 참고하여
Claude Code, OpenAI Codex, Gemini CLI를 하나의 설치 경험으로 통합했습니다.


---

# Windows 설치


PowerShell 실행 후:


```powershell
irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1 | iex
