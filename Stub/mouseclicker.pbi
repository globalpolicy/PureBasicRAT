;mouse clicker include file
XIncludeFile "customtypes.pbi"

EnableExplicit


Procedure mouseClickThreadProc(*params.MouseClickInfo)
  Define i.i
  Define.i mouseButtonDown,mouseButtonUp
  If *params\mouseButton="left"
    mouseButtonDown=#MOUSEEVENTF_LEFTDOWN  
    mouseButtonUp=#MOUSEEVENTF_LEFTUP
  ElseIf *params\mouseButton="right"
    mouseButtonDown=#MOUSEEVENTF_RIGHTDOWN
    mouseButtonUp=#MOUSEEVENTF_RIGHTUP
  ElseIf *params\mouseButton="middle"
    mouseButtonDown=#MOUSEEVENTF_MIDDLEDOWN
    mouseButtonUp=#MOUSEEVENTF_MIDDLEUP
  EndIf
  
  For i=1 To *params\numTimes
    mouse_event_(mouseButtonDown,0,0,0,0)
    mouse_event_(mouseButtonUp,0,0,0,0)
    Delay(*params\interval)  
  Next i

EndProcedure


Procedure ClickThis(numOfTimes.i,interval.i,mouseButton.s)
  Static param.MouseClickInfo ;has to be preserved even after procedure has ended coz it's used in thread
  
  If numOfTimes=0
    numOfTimes=1  
  EndIf  
  
  param\numTimes=numOfTimes
  param\interval=interval
  param\mouseButton=mouseButton
  
  CreateThread(@mouseClickThreadProc(),@param)
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 40
; FirstLine = 13
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier