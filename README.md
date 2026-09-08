# AutoHotkey Vim Style Navigation & IME Switcher

Windows 11 환경에서 **Vim 스타일 키 Navigation**을 제공하고, **`Esc` 입력 시 자동으로 미국 영어(ENG) 키보드로 전환**해 주는 AutoHotkey 스크립트입니다.

---

## ⚠️ [필수] 실행 전 Windows 사전 설정

본 스크립트는 **`Ctrl + 1`** 단축키를 통해 입력 언어를 **영어(미국) - US**로 강제 전환합니다. 
AHK를 실행하기 전에 **반드시 아래 윈도우 설정을 먼저 진행**해야 정상 작동합니다.

### 1. Windows 입력 언어 단축키 설정
1. `Win + R` 키를 눌러 실행 창을 열고 `control input.dll` 입력 (또는 **[설정] -> [시간 및 언어] -> [입력] -> [고급 키 설정]**)
2. **[고급 키 설정]** 탭 클릭
3. `입력 언어의 바로 가기 키` 목록에서 **`영어(미국) - US(으)로`** 항목 선택
4. 하단의 **[키 시퀀스 변경(C)...]** 버튼 클릭
5. **`Ctrl + 1`**로 단축키 지정 후 [확인] 및 [적용] 클릭

> **Note**: 만약 다른 단축키(예: `Ctrl + Shift + 1`)로 설정하셨다면, `.ahk` 코드 내 `Send, ^1` 부분을 설정한 단축키에 맞게 수정해야 합니다.

---

## 🚀 주요 기능 (Key Features)

### 1. Esc / CapsLock 기반 ENG 자동 전환
* **`Esc`**: 눌렀을 때 `Ctrl + 1`을 발송하여 입력기를 **미국 영어(ENG)**로 강제 변경한 후 `Esc` 전달 (Vim Normal 모드 진입 최적화)
* **`CapsLock` (단독 누름)**: 0.2초 이내 단독 클릭 시 `Ctrl + 1` 발송 (영문 전환)

### 2. CapsLock 방향키 & 편집 단축키 (Vim Style)
`CapsLock`을 누른 채로 아래 키를 조합하여 사용합니다.

| 구분 | 조합키 | 기능 |
| :--- | :--- | :--- |
| **이동** | `CapsLock` + `H / J / K / L` | Left / Down / Up / Right (Alt 조합 시 Shift+방향키) |
| **페이지/커서** | `CapsLock` + `U / I / O / P` | PgUp / Home / End / PgDn |
| **삭제** | `CapsLock` + `M / N / B` | Backspace / Ctrl+BS / Shift+Home+Del (앞 단어/줄 삭제) |
| **삭제** | `CapsLock` + `, / . / /` | Delete / Ctrl+Del / Shift+End+Del (뒤 단어/줄 삭제) |
| **편집** | `CapsLock` + `Z / X / C / V / A` | Undo / Cut / Copy / Paste / Select All |
| **창 제어** | `CapsLock` + `S / W / Q` | Ctrl+Tab (탭 전환) / Ctrl+W (탭 닫기) / Alt+F4 (창 닫기) |

---

## 🔧 빌드 및 실행 방법

1. `Ahk2Exe` 컴파일러를 실행합니다.
2. `AutoHotkeyVimHanToEng.ahk` 파일 선택 후 **[Convert]**를 눌러 `.exe` 파일로 빌드합니다.
3. 생성된 `.exe` 파일 우클릭 ➔ **[속성]** ➔ **[호환성]** 탭 ➔ **`관리자 권한으로 이 프로그램 실행`**을 반드시 체크합니다.
4. `Win + R` ➔ `shell:startup` (시작프로그램 폴더)에 해당 `.exe` 파일의 바로가기를 넣으면 부팅 시 자동 실행됩니다.