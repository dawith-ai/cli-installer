# CLI Installer - AI Developer Setup

새 Windows 또는 macOS 컴퓨터에서 AI 코딩 개발 환경을 빠르게 구성하기 위한 설치 도구입니다.

터미널 사용이 익숙하지 않은 사용자도 한 줄 명령만 실행하면 개발 환경과 AI CLI 도구를 설치할 수 있도록 구성했습니다.

지원하는 AI CLI:

- Claude Code
- OpenAI Codex
- Gemini CLI


---

# ✨ Features

CLI Installer는 운영체제에 맞게 필요한 개발 환경을 자동으로 구성합니다.


## Windows

자동 설치:

- Git
- Node.js LTS
- npm
- AI CLI 도구


## macOS

자동 설치:

- Homebrew
- Node.js
- Python
- Git
- Visual Studio Code
- AI CLI 도구


설치 과정에서 원하는 AI CLI를 선택할 수 있습니다.

여러 개를 동시에 설치할 수도 있습니다.

예:

```
1,2
```

입력 시:

```
Claude Code
OpenAI Codex
```

두 개가 함께 설치됩니다.


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


1. Windows 키를 누릅니다.
2. PowerShell을 실행합니다.
3. 아래 명령어를 붙여넣습니다.


```powershell
irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1 | iex
```


설치가 시작되면:

1. Git 설치 확인
2. Node.js 설치 확인
3. AI CLI 선택 메뉴 표시
4. 선택한 CLI 설치

순서로 진행됩니다.


설치 화면 예:

```
설치할 AI CLI를 선택하세요.

[1] Claude Code
[2] OpenAI Codex
[3] Gemini CLI
[4] 전체 설치

선택 (예: 1,2):
```


입력 예:

```
1,2
```


결과:

```
Claude Code 설치
OpenAI Codex 설치
```


---

# 🍎 macOS 설치


## 처음 설치하기


터미널을 열고 아래 명령어를 실행합니다.


```bash
curl -fsSL https://raw.githubusercontent.com/dawith-ai/cli-installer/main/macos/install.sh | bash
```


설치 과정:

1. Homebrew 확인
2. 개발 도구 설치
3. AI CLI 선택
4. 선택한 CLI 설치


선택 화면:

```
설치할 AI CLI를 선택하세요.

[1] Claude Code
[2] OpenAI Codex
[3] Gemini CLI
[4] 전체 설치
```


여러 개 선택:

```
1,3
```


결과:

```
Claude Code
Gemini CLI
```

설치


---

# 🛠 설치 후 사용


설치 완료 후 새 터미널을 열어 실행합니다.


## Claude Code

```bash
claude
```


## OpenAI Codex

```bash
codex
```


## Gemini CLI

```bash
gemini
```


처음 실행 시 각 서비스 로그인 과정이 진행될 수 있습니다.


---

# 🗑 설치 제거


## AI CLI만 제거


### Windows PowerShell

PowerShell에서는 npm 실행 정책 문제를 방지하기 위해 `npm.cmd` 사용을 권장합니다.


```powershell
npm.cmd uninstall -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli
```


### macOS Terminal

```bash
npm uninstall -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli
```


---

# Windows 전체 제거


PowerShell:


```powershell
npm.cmd uninstall -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli

winget uninstall OpenJS.NodeJS.LTS

winget uninstall Git.Git
```


Visual Studio Code를 설치했다면:


```powershell
winget uninstall Microsoft.VisualStudioCode
```


---

# macOS 전체 제거


Terminal:


```bash
npm uninstall -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli

brew uninstall node python git

brew uninstall --cask visual-studio-code
```


---

# 🧪 로컬에서 실행하기


저장소를 내려받습니다.


```bash
git clone https://github.com/dawith-ai/cli-installer.git

cd cli-installer
```


## Windows


PowerShell:


```powershell
.\install.ps1
```


## macOS


Terminal:


```bash
bash ./macos/install.sh
```


---

# 📁 프로젝트 구조


```
cli-installer

├── install.ps1
│   Windows 한 줄 설치용 진입점
│
├── windows
│   └── install.ps1
│       Windows 설치 및 AI CLI 선택 설치
│
├── macos
│   └── install.sh
│       macOS 설치 및 AI CLI 선택 설치
│
└── README.md
```


---

# 🔐 보안 안내


CLI Installer는 GitHub에서 설치 스크립트를 받아 실행합니다.


실행 전에 저장소 코드를 확인하는 것을 권장합니다.


로컬 실행:


```bash
git clone https://github.com/dawith-ai/cli-installer.git

cd cli-installer
```


직접 코드를 확인한 후 실행할 수 있습니다.


---

# ➕ 새로운 AI CLI 추가하기


새로운 AI CLI를 추가하려면:


1. npm 패키지 확인
2. Windows 설치 함수 추가
3. macOS 설치 함수 추가
4. 선택 메뉴 항목 추가


동일한 구조로 새로운 CLI 도구를 확장할 수 있습니다.


---

# 🎯 프로젝트 목적


AI 코딩 도구를 처음 사용하는 사용자가:


- 개발 환경 설치
- Node.js 설치
- Git 설치
- CLI 설치
- 초기 설정


과정을 반복하지 않고,


새로운 컴퓨터에서도 빠르게 AI 개발 환경을 구성할 수 있도록 만드는 것이 목표입니다.


---

# License

MIT License
