#Persistent
#SingleInstance Force
#InstallKeybdHook
; Alt 단독 훅이 기본 Ctrl 마스크를 보내면 한글이 풀림 + 확장키(RShift) 꼬임
; 미사용 키로 메뉴 마스크 (Ctrl/Alt 아님)
#MenuMaskKey vkE8
; CapsLock 시작 시 OFF만 (AlwaysOff 금지 — 켜지지 않는 문제 방지)
SetCapsLockState, Off

;;==================== IME SWITCHING SHORTCUTS START =====================;;

; 1. Esc 단독: 미국 영어(ENG) 모드로 전환 (Vim Normal 모드)
$Esc::
    Send, ^1        ; Ctrl + 1 (영어(미국) - US 전환)
    Send, {Escape}  ; Esc 전달
    return 

; 2. LShift + Esc: 한국어 전환 후 즉시 '가' 모드로 강제 설정
;    ※ +Esc 금지 — 양쪽 Shift 훅이 RShift+2(@)를 깨뜨림
;    ※ ~LShift — LShift를 prefix로 고정하지 않음 (대문자/기호 유지)
~LShift & Esc::
    Send, #{Space}  ; Win + Space (한국어 전환)
    Sleep, 150      ; IME 반응 대기시간 소폭 증가
    Send, {VK21}    ; 한/영 전환 키 (A -> '가' 변경)
    return

; 3. Ctrl + Esc: 중국어 입력기로 전환 (윈도우 기본 Ctrl+Esc 시작메뉴 간섭 방지)
^Esc::
    Send, ^`        ; Ctrl + ` (중국어 IME 전환)
    return

; CapsLock 단독: 대문자 락 끄고 영어(US). (켜기/끄기는 LShift+CapsLock)
; $ = OS 기본 CapsLock 토글 차단
$CapsLock::
    KeyWait, CapsLock, T0.2
    if !ErrorLevel {
        SetCapsLockState, Off
        Send, ^1    ; 단독 → 영어(미국)
    } else {
        ; 조합키(CapsLock+h 등) 사용 중 — 락은 켜지지 않게 유지
        SetCapsLockState, Off
    }
    return

; 4. Alt 단독 (좌·우):
;    - Vim 계열: Insert(edit) + 한국어
;    - 그 외: 한국어만
;    ※ vk15/sc138 전송 금지 — RAlt·RShift 확장키 꼬임 방지
;    ※ Alt 직후 Ctrl 전송 금지 — IME 한글이 다시 풀림
~LAlt Up::
    if (A_PriorKey != "LAlt")
        return
    AltAloneAction()
    return

~RAlt Up::
    if (A_PriorKey != "RAlt")
        return
    AltAloneAction()
    return

AltAloneAction() {
    if (IsVimEditor())
        VimEnterInsert()
    SwitchToHangul()
}

; vscodevim / Vim / Neovim 등
IsVimEditor() {
    WinGet, exe, ProcessName, A
    if (exe = "")
        return 0
    StringLower, exe, exe
    ; 네이티브 Vim
    if exe in gvim.exe,vim.exe,nvim.exe,nvim-qt.exe,neovide.exe,goneovim.exe
        return 1
    ; VS Code 계열 + vim 확장 사용 전제 (Esc=Normal/ENG 워크플로)
    if exe in code.exe,code - insiders.exe,cursor.exe,trae.exe,windsurf.exe,vscodium.exe
        return 1
    return 0
}

; Insert 모드 진입. $Esc 핫키(ENG 전환)는 잠시 끄고 Esc 전송
VimEnterInsert() {
    Hotkey, $Esc, Off
    SendInput {Esc}
    Sleep, 20
    SendInput i
    Hotkey, $Esc, On
}

; layoutName 예: "00000412"=한국어
SetInputLanguage(layoutName) {
    WinGet, hWnd, ID, A
    if !hWnd
        return
    hkl := DllCall("LoadKeyboardLayout", "Str", layoutName, "UInt", 1)
    if !hkl
        return
    DllCall("ActivateKeyboardLayout", "UInt", hkl, "UInt", 0)
    PostMessage, 0x50, 0, %hkl%,, ahk_id %hWnd%
}

; 현재 한글(가) 여부 (1=한글, 0=영문/실패)
IME_IsHangul(WinTitle="A") {
    WinGet, hWnd, ID, %WinTitle%
    if !hWnd
        return 0
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd, "UInt")
    if !DefaultIMEWnd
        return 0
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows, On
    SendMessage, 0x283, 0x005, 0,, ahk_id %DefaultIMEWnd%
    result := ErrorLevel
    DetectHiddenWindows, %DetectSave%
    if result is not integer
        return 0
    return result
}

; IME: 한글(가) ON + 전각 OFF (IMM만 사용 — vk15/한영키는 RAlt와 동일)
IME_ForceHangul(WinTitle="A") {
    WinGet, hWnd, ID, %WinTitle%
    if !hWnd
        return
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd, "UInt")
    if !DefaultIMEWnd
        return
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows, On
    SendMessage, 0x283, 0x001, 0,, ahk_id %DefaultIMEWnd%
    mode := ErrorLevel
    if mode is integer
    {
        ; NATIVE=0x1 on, FULLSHAPE=0x8 off
        mode := (mode | 0x1) & ~0x8
        SendMessage, 0x283, 0x002, %mode%,, ahk_id %DefaultIMEWnd%
    }
    SendMessage, 0x283, 0x006, 1,, ahk_id %DefaultIMEWnd%
    DetectHiddenWindows, %DetectSave%
}

; Alt 단독 → 한국어 + 한글(가) + 반각
SwitchToHangul() {
    SetInputLanguage("00000412")
    Sleep, 40
    IME_ForceHangul()
}

;;==================== IME SWITCHING SHORTCUTS END =====================;;


;;==================== CapsLock Navigation & Shortcuts =====================;;
; Ctrl+C / Ctrl+V 는 OS 기본 동작 유지 (예전에 Ctrl+Insert/Shift+Insert로
; 가로채면 일반 앱에서 복사·붙여넣기가 안 됨)
; LShift+CapsLock / LAlt+CapsLock = 실제 CapsLock ON/OFF 토글
; ※ +CapsLock / !CapsLock 금지 — RShift·RAlt 수정키와 충돌
~LShift & CapsLock::
~LAlt & CapsLock::
    if GetKeyState("CapsLock", "T")
        SetCapsLockState, Off
    else
        SetCapsLockState, On
    return

Pause::Insert

; Navigator
CapsLock & u:: Send, % GetKeyState("alt") ? "+{PgUp}" : "{PgUp}"
CapsLock & i:: Send, % GetKeyState("alt") ? "+{Home}" : "{Home}"
CapsLock & o:: Send, % GetKeyState("alt") ? "+{End}"  : "{End}"
CapsLock & p:: Send, % GetKeyState("alt") ? "+{PgDn}" : "{PgDn}"

CapsLock & h:: Send, % GetKeyState("alt") ? "+{Left}" : "{Left}"
CapsLock & j:: Send, % GetKeyState("alt") ? "+{Down}" : "{Down}"
CapsLock & k:: Send, % GetKeyState("alt") ? "+{Up}"   : "{Up}"
CapsLock & l:: Send, % GetKeyState("alt") ? "+{Right}": "{Right}"

; Deletor
CapsLock & ,:: Send, {Del}
CapsLock & .:: Send, ^{Del}
CapsLock & /:: Send, +{End}{Del}
CapsLock & m:: Send, {BS}
CapsLock & n:: Send, ^{BS}
CapsLock & b:: Send, +{Home}{Del}

; Special Char
CapsLock & ':: Send, +'
CapsLock & `;:: Send, +`;
CapsLock & [:: 
    Send, ^1
    Send, +[
    return
CapsLock & ]:: Send, +]
CapsLock & `:: Send, +``
CapsLock & 4:: Send, +4
CapsLock & 5:: Send, +5
CapsLock & 6:: Send, +6
CapsLock & 7:: Send, +7
CapsLock & 8:: Send, +8
CapsLock & 9:: Send, +9
CapsLock & 0:: Send, +0
CapsLock & Enter:: Send, {End}{Enter}{Up}
CapsLock & -:: Send, +-
CapsLock & =:: Send, +=
CapsLock & \:: Send, +=

; Editor
CapsLock & z:: Send, ^z
CapsLock & x:: Send, ^x
CapsLock & c:: Send, ^c
CapsLock & v:: Send, ^v
CapsLock & a:: Send, ^a
CapsLock & y:: Send, ^y

; Controller
CapsLock & s:: Send, ^{Tab}
CapsLock & w:: Send, ^w
CapsLock & q:: Send, !{F4}
;;==================== Navicat: Ctrl+Enter = Run Selected (Ctrl+R) =====================;;
; Navicat Query Editor: Ctrl+R = Run / Run Selected (with selection => Run Selected)
; Ctrl & Enter 금지 — Ctrl을 prefix로 만들면 다른 수정키(RShift 등)와 충돌
$^Enter::
$^NumpadEnter::
    if !WinActive("ahk_exe navicat.exe") {
        SendInput {Blind}{Enter}
        return
    }
    SendInput {Blind}^r
    return
