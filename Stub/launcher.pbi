;include file for launching self from the right folder
XIncludeFile "configreader.pbi"
EnableExplicit

Procedure LaunchFromRightFolder()
  Define dropPath.s,exeName.s,selfPath.s
  exeName=getExeName()
  dropPath=getDropPath()+"\"+exeName+".exe"
  selfPath=GetSelfPath()
  If Not LCase(selfPath)=LCase(dropPath)
    DeleteFile(dropPath,#PB_FileSystem_Force)
    CopyFile(selfPath,dropPath)
    RunProgram(dropPath)
    End
  EndIf
EndProcedure


Procedure LaunchSelfAndQuit()
  ;this procedure is called if self has been run with the "/task" switch (when executed by the task scheduler)
  Define selfpath.s
  selfpath=GetSelfPath() ;get exe path (without the switch)
  RunProgram(selfpath)   ;run the exe
  End
EndProcedure

;references
;http://forums.codeguru.com/showthread.php?283973-Shell-execute-a-program-but-change-it-s-working-directory
;https://stackoverflow.com/questions/33698946/how-to-change-start-directory-of-an-scheduled-task-with-schtasks-exe-in-windows
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 28
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier