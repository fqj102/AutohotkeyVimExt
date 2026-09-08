#Persistent
#SingleInstance Force

;;==================== SWITCH TO ENG VIA CTRL+1 (Esc) START =====================;;

$Esc::
    Send, ^1        ; Windows 설정에 지정된 Ctrl+1 (영어(미국) - US 전환) 발송
    Send, {Escape}  ; Esc 키 전달 (Vim Normal 모드 진입)
    return 

CapsLock::
    KeyWait, CapsLock, T0.2
    if ErrorLevel {
        ; CapsLock 조합키 사용 중
    } else {
        Send, ^1    ; CapsLock 단독 입력 시에도 영어(미국)로 전환
    }
    return
;;==================== SWITCH TO ENG VIA CTRL+1 (Esc) END =====================;;


;;==================== VISUAL MODE CTRL+C,CTRL+V =====================;;
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