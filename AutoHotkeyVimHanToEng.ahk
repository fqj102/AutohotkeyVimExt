#Persistent
#SingleInstance Force
; CapsLock 시작 시 OFF만 (AlwaysOff 금지 — 켜지지 않는 문제 방지)
SetCapsLockState, Off

;;==================== IME SWITCHING SHORTCUTS START =====================;;

; 1. Esc 단독: 미국 영어(ENG) 모드로 전환 (Vim Normal 모드)
$Esc::
    Send, ^1        ; Ctrl + 1 (영어(미국) - US 전환)
    Send, {Escape}  ; Esc 전달
    return 

; 2. Shift + Esc: 한국어 전환 후 즉시 '가' 모드로 강제 설정
+Esc::
    Send, #{Space}  ; Win + Space (한국어 전환)
    Sleep, 150      ; IME 반응 대기시간 소폭 증가
    Send, {VK21}    ; 한/영 전환 키 (A -> '가' 변경)
    return

; 3. Ctrl + Esc: 중국어 입력기로 전환 (윈도우 기본 Ctrl+Esc 시작메뉴 간섭 방지)
^Esc::
    Send, ^`        ; Ctrl + ` (중국어 IME 전환)
    return

; CapsLock 단독: 대문자 락 끄고 영어(US). (켜기/끄기는 Shift+CapsLock)
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

; 4. Alt 단독: 한국어 한글(가) + 반각(반자) 모드
;    전각(FULLSHAPE)이 켜지면 Space가 비정상적으로 넓어짐 → 반드시 해제
;    Alt+Tab 등 조합은 ~ 로 통과, 단독 Alt 메뉴 활성화는 무해 키로 취소
~LAlt Up::
    if (A_PriorKey != "LAlt")
        return
    SwitchToHangul()
    ; Alt 단독 후 메뉴바 포커스 방지 (입력란에 Space 영향 없음)
    SendInput, {Blind}{Ctrl}
    return

~RAlt Up::
    if (A_PriorKey != "RAlt")
        return
    SwitchToHangul()
    SendInput, {Blind}{Ctrl}
    return

; 명시적 입력 언어 전환 (Win+Space 사이클 금지 — 중국어 zh-CN 등 우회)
; layoutName: "00000412"=한국어
SetInputLanguage(layoutName) {
    WinGet, hWnd, ID, A
    if !hWnd
        return
    ; KLF_ACTIVATE=1
    hkl := DllCall("LoadKeyboardLayout", "Str", layoutName, "UInt", 1)
    if !hkl
        return
    ; WM_INPUTLANGCHANGEREQUEST = 0x50
    PostMessage, 0x50, 0, %hkl%,, ahk_id %hWnd%
}

; IME: 한글(가) ON + 전각(FULLSHAPE) OFF (넓은 공백 원인)
IME_ForceHangul(WinTitle="A") {
    WinGet, hWnd, ID, %WinTitle%
    if !hWnd
        return
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd, "UInt")
    if !DefaultIMEWnd
        return
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows, On
    ; IMC_GETCONVERSIONMODE = 0x001
    SendMessage, 0x283, 0x001, 0,, ahk_id %DefaultIMEWnd%
    mode := ErrorLevel
    if (mode = "")
        mode := 0
    ; IME_CMODE_NATIVE(한글)=0x1 켜기, IME_CMODE_FULLSHAPE(전각)=0x8 끄기
    mode := (mode | 0x1) & ~0x8
    ; IMC_SETCONVERSIONMODE = 0x002
    SendMessage, 0x283, 0x002, %mode%,, ahk_id %DefaultIMEWnd%
    ; IMC_SETOPENSTATUS = 0x006 → 한글(가) 열기
    SendMessage, 0x283, 0x006, 1,, ahk_id %DefaultIMEWnd%
    DetectHiddenWindows, %DetectSave%
}

; Alt 단독 → 한국어 레이아웃 + 한글(가) + 반각
SwitchToHangul() {
    SetInputLanguage("00000412")
    Sleep, 50
    IME_ForceHangul()
}

;;==================== IME SWITCHING SHORTCUTS END =====================;;


;;==================== VISUAL MODE CTRL+C, CTRL+V =====================;;
^c::Send {Ctrl down}{Insert}{Ctrl Up}
^v::Send {Shift down}{Insert}{Shift Up}


;;==================== CapsLock Navigation & Shortcuts =====================;;
; Shift+CapsLock / Alt+CapsLock = 실제 CapsLock ON/OFF 토글
+CapsLock::
!CapsLock::
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
#InstallKeybdHook
#UseHook
Ctrl & Enter::
^NumpadEnter::
    if !WinActive("ahk_exe navicat.exe") {
        SendInput {Blind}{Enter}
        return
    }
    ; Ctrl already down -> send r => Ctrl+R => Run Selected
    SendInput {Blind}r
    return
