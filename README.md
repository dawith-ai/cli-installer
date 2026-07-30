# OneShot AI Developer Setup

새 Windows 또는 macOS 컴퓨터에서 AI 코딩 환경을 한 번에 준비합니다. 터미널이 처음이어도 아래 명령 한 줄만 실행하면 됩니다.

기본 설치에는 Node.js, Python, Git, VS Code, Claude Code, OpenAI Codex가 포함됩니다. Gemini CLI는 `All` 프로필에서 함께 설치할 수 있습니다.

## Windows: 처음 설치하기

1. 키보드에서 `Windows 키`를 누르고 **PowerShell**을 검색해 엽니다.
2. 아래 한 줄을 복사해 붙여넣고 Enter를 누릅니다.

```powershell
irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1 | iex
```

설치 중 Windows가 확인 창을 표시하면 내용을 확인한 후 허용하세요. 설치가 끝나면 아래 중 하나를 입력해 AI 코딩을 시작할 수 있습니다.

```powershell
codex
claude
```

처음 실행할 때 각 서비스의 로그인 과정이 열릴 수 있습니다.

## macOS: 처음 설치하기

터미널을 열고 실행합니다.

```bash
curl -fsSL https://raw.githubusercontent.com/dawith-ai/cli-installer/main/macos/install.sh | bash
```

## 설치 프로필

| 프로필 | 설치되는 AI 도구 | 실행 예시 |
| --- | --- | --- |
| `Essential` (기본) | Claude Code, Codex | 기본 한 줄 명령 |
| `All` | Claude Code, Codex, Gemini CLI | 아래 PowerShell 예시 |
| `Custom` | 원하는 도구만 | `claude`, `codex`, `gemini` 중 선택 |

Windows에서 모든 AI 도구를 설치하려면 다음을 실행하세요.

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1))) -Profile All
```

Codex와 Gemini만 설치하려면 다음과 같습니다.

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/dawith-ai/cli-installer/main/install.ps1))) -Profile Custom -Tools codex,gemini -NoPrompt
```

Python 또는 Git을 제외해야 한다면 `-SkipPython`, `-SkipGit` 옵션을 추가할 수 있습니다.

## 설치 후 점검

로컬 저장소에서 실행하는 경우 다음 명령으로 현재 환경을 점검합니다.

```powershell
.\windows\doctor.ps1
```

`OK`가 표시된 도구는 준비된 상태입니다. `없음`으로 표시되면 새 PowerShell 창을 연 뒤 다시 확인하세요.

## 처음 해볼 일

프로젝트 폴더를 하나 만든 뒤 아래처럼 AI에게 부탁해 보세요.

```powershell
mkdir my-first-app
cd my-first-app
codex
```

예시 요청:

- "이 폴더에 간단한 할 일 목록 웹앱을 만들어줘."
- "현재 파일 구조를 설명하고 README를 작성해줘."
- "실행 오류를 읽고 원인과 수정 방법을 알려줘."

## 프로젝트 구조

```text
install.ps1                 Windows 한 줄 설치용 호환 진입점
windows/install.ps1         Windows 설치 흐름과 프로필 처리
windows/modules/            공통 설치·PATH·winget 기능
windows/providers/          Claude, Codex, Gemini 각각의 설치 정의
windows/doctor.ps1          설치 결과 점검
macos/install.sh            Homebrew 기반 macOS 설치기
```

새 AI CLI를 추가하려면 `windows/providers`에 provider 파일을 만들고 `windows/install.ps1`의 installer 목록에 등록하면 됩니다. macOS의 `case` 문에도 같은 npm 패키지를 한 항목 추가합니다.

## 요구 사항 및 보안

- Windows 10 1809 이상 또는 Windows 11: **App Installer(winget)** 가 필요합니다.
- macOS: 관리자 비밀번호와 인터넷 연결이 필요할 수 있습니다.
- 한 줄 설치는 GitHub에서 스크립트를 받아 즉시 실행합니다. 실행 전 저장소의 코드를 확인하고, 가능하면 저장소를 내려받아 로컬에서 실행하세요.

```powershell
git clone https://github.com/dawith-ai/cli-installer.git
cd cli-installer
.\install.ps1
```
