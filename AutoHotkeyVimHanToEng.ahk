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