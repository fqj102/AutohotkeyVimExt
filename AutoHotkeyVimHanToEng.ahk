#Persistent
#SingleInstance Force

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

; CapsLock 단독 누름: 기본 미국 영어(ENG)로 전환
CapsLock::
    KeyWait, CapsLock, T0.2
    if ErrorLevel {
        ; CapsLock 조합키 사용 중
    } else {
        Send, ^1    ; 단독 입력 시 영어(미국)로 전환
    }
    return

; 4. Alt 단독: 즉시 한국어 한글(가)로 전환 (토글 아님, 중국어로 가지 않음)
;    Alt+Tab 등 조합키는 ~ 로 그대로 통과
~LAlt Up::
    if (A_PriorKey != "LAlt")
        return
    SwitchToHangul()
    return

~RAlt Up::
    if (A_PriorKey != "RAlt")
        return
    SwitchToHangul()
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

; IME를 한글(가)로 강제 — 한/영 토글 키(vk15) 사용 금지 (이미 한글이면 영어로 뒤집힘)
IME_ForceHangul(WinTitle="A") {
    WinGet, hWnd, ID, %WinTitle%
    if !hWnd
        return
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd, "UInt")
    if !DefaultIMEWnd
        return
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows, On
    ; WM_IME_CONTROL(0x283) + IMC_SETOPENSTATUS(0x006) + 1 = 항상 한글(가)
    SendMessage, 0x283, 0x006, 1,, ahk_id %DefaultIMEWnd%
    DetectHiddenWindows, %DetectSave%
}

; Alt 단독 → 항상 한국어(00000412) + 한글(가)만. 영어 전환/토글 없음, Win+Space 없음
SwitchToHangul() {
    SetInputLanguage("00000412")
    Sleep, 80
    IME_ForceHangul()
}

;;==================== IME SWITCHING SHORTCUTS END =====================;;


;;==================== VISUAL MODE CTRL+C, CTRL+V =====================;;
^c::Send {Ctrl down}{Insert}{Ctrl Up}
^v::Send {Shift down}{Insert}{Shift Up}


;;==================== CapsLock Navigation & Shortcuts =====================;;
SetCapsLockState, AlwaysOff
+CapsLock::CapsLock
!CapsLock::CapsLock

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