# CLI Installer - AI Developer Setup

새 Windows 또는 macOS 컴퓨터에서 AI 코딩 개발 환경을 빠르게 구성하기 위한 설치 도구입니다.

터미널 사용이 익숙하지 않은 사용자도 한 줄 명령어 실행만으로 개발 환경과 AI CLI 도구를 설치할 수 있도록 구성했습니다.

지원하는 AI CLI:

- Claude Code
- OpenAI Codex
- Gemini CLI


---

# ✨ Features

CLI Installer는 운영체제에 맞춰 필요한 개발 환경을 자동으로 구성합니다.


## Windows

자동 설치:

- Git
- Node.js LTS
- npm
- AI CLI 도구
- (필요 시) PowerShell 실행 정책 자동 설정


## macOS

자동 설치:

- Homebrew
- Node.js
- Python
- Git
- Visual Studio Code
- AI CLI 도구


설치 과정에서 원하는 AI CLI를 직접 선택할 수 있습니다.


지원 방식:

- Claude Code 단독 설치
- OpenAI Codex 단독 설치
- Gemini CLI 단독 설치
- 여러 개 동시 설치
- 전체 설치


---

# 🙏 참고 및 출처 (Credits)

이 프로젝트는 아래 오픈소스 프로젝트의 설치 구조와 아이디어를 참고하여 제작되었습니다.


## Windows 참고

https://github.com/jikime/oneshot-installer-for-window


Windows 환경에서 개발 도구를 자동 설치하는 방식과 설치 흐름을 참고했습니다.


## macOS 참고

https://github.com/jikime/oneshot-installer-for-mac


macOS 환경에서 Homebrew 기반으로 개발 환경을 구성하는 방식을 참고했습니다.


원본 프로젝트를 공유해주신  
앤써니(Anthony Kim / jikime)님께 감사드립니다.


본 프로젝트는 위 프로젝트의 구조와 아이디어를 참고하여:

- Claude Code
- OpenAI Codex
- Gemini CLI

를 하나의 설치 과정으로 구성하고 Windows와 macOS 환경에서 쉽게 사용할 수 있도록 확장했습니다.


---

# 🚀 Windows 설치


## 처음 설치하기


Windows PowerShell을 실행합니다.

### PowerShell 여는 법

다음 중 편한 방법을 사용하세요.

- **단축키**: `Win + X` 를 누른 뒤 **"Windows PowerShell"** 또는 **"터미널"** 선택
- **검색으로 열기**: `Win` 키를 누르고 `PowerShell` 입력 → Enter
- **실행 창으로 열기**: `Win + R` → `powershell` 입력 → Enter
- **탐색기 경로**: `시작 메뉴` → `Windows PowerShell` 폴더 안에서 실행


아래 명령어를 그대로 붙여넣습니다.


```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1'))
```

> ⚠️ **설치가 끝나면 새 PowerShell 창이 자동으로 하나 열립니다. `claude`, `codex`, `gemini` 같은 명령어는 반드시 그 새 창에서 실행해주세요.**
> 원래 쓰던 창(설치를 실행한 창)에서 바로 입력하면 `claude : 용어가 cmdlet, 함수... 이름으로 인식되지 않습니다` 오류가 나는데, 이는 정상적인 현상입니다 (Windows가 실행 중인 창의 PATH를 자동으로 갱신하지 않기 때문입니다). 원래 창은 닫으셔도 됩니다.


설치가 시작되면:

1. Git 설치
2. Node.js 설치
3. AI CLI 선택 화면 표시
4. 선택한 AI CLI 설치
5. 새 PowerShell 창 자동 실행


순서로 진행됩니다.


예:
