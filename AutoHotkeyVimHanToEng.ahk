;;====================FANG HAN TO ENG START =====================;;

$Esc::
    IME_CHANGE()
    return 
/*
^C::
    IME_CHANGE()
    return
*/
CapsLock::
    IME_CHANGE()
    return

/*
; already used 
CapsLock & [::
    IME_CHANGE()
    return 
*/

IME_CHANGE() {
    if(IME_CHECK("A"))
        Send, {VK15}    ; kor => eng
    Send, {Escape}
    return
}

IME_CHECK(WinTitle) {
  WinGet,hWnd,ID,%WinTitle%
  Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}

Send_ImeControl(DefaultIMEWnd, wParam, lParam) {
  DetectSave := A_DetectHiddenWindows
  DetectHiddenWindows,ON
   SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
  if (DetectSave <> A_DetectHiddenWindows)
      DetectHiddenWindows,%DetectSave%
  return ErrorLevel
}
ImmGetDefaultIMEWnd(hWnd) {
  return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}
;;====================FANG HAN TO ENG END =====================;;


;;====================FANG IN VISUAL MODE CTRL+C,CTRL+V START =====================;;
; vim on visual mode use ctrl + c , ctrl + v   
^c::Send {Ctrl down}{Insert}{Ctrl Up}
^v::Send {Shift down}{Insert}{Shift Up}
;;====================FANG IN VISUAL MODE CTRL+C,CTRL+V END =======================;;












;;====================Feng Ruohang's AHK Script=====================;;
;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;
SetCapsLockState, AlwaysOff
shift & capslock::capslock
alt & capslock::capslock


Pause::Insert   ;; F13  or pause to insert
;;=============================Navigator============================||
;===========================;CapsLock+U = PageDown
CapsLock & u::
if getkeystate("alt") = 0
Send, {PgUp}
else
Send, +{PgUp}
return
;===========================;CapsLock+I = Home
CapsLock & i::
if getkeystate("alt") = 0
Send, {Home}
else
Send, +{Home}
return
;===========================;CapsLock+O = End
CapsLock & o::
if getkeystate("alt") = 0
Send, {End}
else
Send, +{End}
return
;===========================;CapsLock+P = PageDown
CapsLock & p::
if getkeystate("alt") = 0
Send, {PgDn}
else
Send, +{PgDn}
return
;===========================;CapsLock+H = Left
CapsLock & h::
if getkeystate("alt") = 0
Send, {Left}
else
Send, +{Left}
return
;===========================;CapsLock+J = Down
CapsLock & j::
if getkeystate("alt") = 0
Send, {Down}
else
Send, +{Down}
return
;===========================;CapsLock+K = UP
CapsLock & k::
if getkeystate("alt") = 0
Send, {Up}
else
Send, +{Up}
return
;===========================;CapsLock+L = Right
CapsLock & l::
if getkeystate("alt") = 0
Send, {Right}
else
Send, +{Right}
return

;;=============================Deletor==============================||
CapsLock & ,:: Send, {Del}              ; CapsLock+, = Del char after
CapsLock & .:: Send, ^{Del}             ; CapsLock+. = Del word after
CapsLock & /:: Send, +{End}{Del}        ;CapsLock+ / = Del all  after

CapsLock & m:: Send, {BS}               ; CapsLock+m = Del char before; 
CapsLock & n:: Send, ^{BS}              ; CapsLock+n = Del word before; 			
CapsLock & b:: Send, +{Home}{Del}       ; CapsLock+b = Del all  before; 

;;============================Special Char==========================||
CapsLock & ':: Send, +'                  
CapsLock & `;:: Send,+`;       
;CapsLock & [:: Send, +[              
CapsLock & [:: 
    IME_CHANGE() 
    Send, +[              
CapsLock & ]:: Send, +]			
CapsLock & `:: Send, +``                ; Shift
CapsLock & 4:: Send, +4
CapsLock & 5:: Send, +5
CapsLock & 6:: Send, +6
CapsLock & 7:: Send, +7
CapsLock & 8:: Send, +8
CapsLock & 9:: Send, +9
CapsLock & 0:: Send, +0
CapsLock & enter:: Send, {End}{Enter} {UP}  
CapsLock & -:: Send, +-
CapsLock & =:: Send, +=
CapsLock & \:: Send, +=
;;============================Editor================================||
CapsLock & z:: Send, ^z                 ; Z = Cancel
CapsLock & x:: Send, ^x                 ; X = Cut
CapsLock & c:: Send, ^c                 ; C = Copy
CapsLock & v:: Send, ^v                 ; V = Paste
CapsLock & a:: Send, ^a					; A = Select All
CapsLock & y:: Send, ^y                	; Y = Redo
;;===========================Controller=============================||
CapsLock & s:: Send, ^{Tab}             ; Switch Tag    S = {Ctr + Tab}
CapsLock & w:: Send, ^w                 ; Close Tag     W = {Ctr + W}
CapsLock & q:: Send, !{F4}              ; Close Window  Q = {Alt + F4}
              ; CapsLock::Send, {ESC}     ;Vimer's love	Capslock = {ESC}

										; Run Notepad++	T = {Text Editor}

;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;