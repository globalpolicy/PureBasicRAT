;logger include file. useful for debugging.
XIncludeFile "datetime.pbi"

EnableExplicit

Procedure LogMsg(msg.s)
  If OpenFile(0,GetEnvironmentVariable("tmp")+"\shiltimur_log.txt",#PB_File_Append)
    WriteString(0,msg+" @ "+GetDateTime()+#CRLF$)
    CloseFile(0)
  EndIf
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 10
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier