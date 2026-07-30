# CLI Installer

새 Windows 또는 macOS 환경에서 AI 코딩 CLI 환경을 자동으로 구성하는 설치 도구입니다.

터미널이 익숙하지 않아도 아래 한 줄만 실행하면 필요한 개발 환경을 준비할 수 있습니다.

설치 과정에서:
- Git
- Node.js
- Python
- VS Code
- Claude Code
- OpenAI Codex
- Gemini CLI

를 선택적으로 설치할 수 있습니다.

---

# 🙏 Credits

이 프로젝트는 아래 오픈소스 프로젝트를 참고하여 제작되었습니다.

- jikime/oneshot-installer-for-window
- jikime/oneshot-installer-for-mac

Windows와 macOS 개발 환경 자동 구성 방식과 설치 흐름을 참고했습니다.

원본 프로젝트를 공유해주신 Anthony Kim(jikime)님께 감사드립니다.

본 프로젝트는 참고한 구조를 기반으로 Claude Code, OpenAI Codex, Gemini CLI를 하나의 설치 과정으로 통합하고 Windows/macOS 환경에서 쉽게 사용할 수 있도록 확장했습니다.

---

# Windows 설치

PowerShell 실행 후 아래 한 줄만 입력합니다.

```powershell
irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1 | iex
