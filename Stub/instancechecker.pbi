;include file for checking multiple instances of self
XIncludeFile "configreader.pbi"
EnableExplicit

Procedure IsAnotherInstanceRunning()
  Define mutexName.s,error.i
  mutexName=getMutexName()
  CreateMutex_(0,#True,mutexName)
  error=GetLastError_()
  If error=#ERROR_ALREADY_EXISTS
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf  
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 13
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier