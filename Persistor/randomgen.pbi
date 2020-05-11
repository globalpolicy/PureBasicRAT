;include file for random number/string generation
EnableExplicit

Procedure.s GetRandomString(length.i)
  Define charset.s="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"    
  Define i.i,buffer.s
  For i=1 To length
    buffer=buffer+Mid(charset,Random(Len(charset),1),1)
  Next i
  ProcedureReturn buffer
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
Define i.i
For i=1 To 10
  Debug GetRandomString(24)
  Delay(1000)
Next i
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier