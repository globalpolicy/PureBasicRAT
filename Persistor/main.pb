;persistor is always executed by the server with a commandline parameter that gives the server's path
;a copy is made off this path into the local directory where the persistor resides
XIncludeFile "randomgen.pbi"

EnableExplicit

Prototype GetModuleFileNameEx(hProcess.i,hModule.i,lpFilename.i,nSize.i)
Global GetModuleFileNameEx_.GetModuleFileNameEx=GetFunction(OpenLibrary(#PB_Any,"psapi.dll"),"GetModuleFileNameExW")

Define serverpath.s,*serverContents,serverSize.q
Define i,error.i,copyTo.s,serverCopy.s
Define installPath.s

Declare.i IsServerRunning(serverPath.s)
Declare LaunchFromRightPath(installPath.s,serverPath.s)

OpenWindow(0,0,0,0,0,"Shiltimur Persistor Window Title", #PB_Window_Invisible | #PB_Window_NoActivate) ;this is for discovery by the server

SetCurrentDirectory(GetPathPart(ProgramFilename())) ;set local directory as the working directory. saves headaches.

serverpath=ProgramParameter(0) ;location of the calling server executable

installPath=ProgramParameter(1) ;location of our install path. this is where we'll copy ourselves and run from.

serverSize=FileSize(serverpath)

If serverSize>0 ;no point in continuing if the server doesn't exist
  
  LaunchFromRightPath(installPath,serverpath);
  
  CreateMutex_(0,#True,"Shiltimur_Persistor_Mutex")
  
  error=GetLastError_()
  
  If Not error=#ERROR_ALREADY_EXISTS ;if another instance is NOT running
    
    copyTo=GetEnvironmentVariable("tmp")+"\"+GetRandomString(10)+".exe"
    
    If CopyFile(serverpath,copyTo) ;copy the server executable from the serverpath to temp with a random name
      
      *serverContents=AllocateMemory(serverSize)
      
      If OpenFile(0,copyTo,#PB_File_SharedRead)
        
        ReadData(0,*serverContents,serverSize)
        
        CloseFile(0)
        
        DeleteFile(copyTo,#PB_FileSystem_Force) ;delete the file
        
        Repeat
          
          If Not IsServerRunning(serverpath)
          
            serverCopy=GetEnvironmentVariable("tmp")+"\"+GetRandomString(10)+".exe"
            
            If OpenFile(0,serverCopy,#PB_File_SharedWrite)
              
              WriteData(0,*serverContents,serverSize)
              
              CloseFile(0)
              
              RunProgram(serverCopy)
              
              Delay(1000) ;allow the process to do its stuff and go to the right directory
            
              DeleteFile(serverCopy) ;delete the server copy
              
              Continue ;don't need additional delay
                          
            EndIf

          EndIf
          
          Delay(1000)
          
        ForEver
        
      EndIf
      
    EndIf
    
  EndIf

EndIf

Procedure.i IsServerRunning(serverPath.s)
  Define serverHwnd.i, retval.i, pid.i, hProcess.i, pathBuffer.s
  pathBuffer=Space(512)
  serverHwnd=FindWindow_(0,"Shiltimur Server Window Title")
  If serverHwnd
    GetWindowThreadProcessId_(serverHwnd,@pid)
    hProcess=OpenProcess_(#PROCESS_QUERY_INFORMATION | #PROCESS_VM_READ,#False,pid)
    If hProcess
      If GetModuleFileNameEx_(hProcess,0,@pathBuffer,512)
        If LCase(serverpath)=LCase(pathBuffer)
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

Procedure LaunchFromRightPath(installPath.s,serverPath.s)
  ;if current program path is not installPath, copy there and run from there and exit this instance
  Define installTo.s
  installTo =Trim(installPath)
  If installTo<>""
    ;landing here means we're not in the right directory
    CopyFile(ProgramFilename(),installPath)
    RunProgram(installPath,#DQUOTE$+serverpath+#DQUOTE$,"")
    End
  EndIf
  
EndProcedure


;references
;https://www.purebasic.fr/english/viewtopic.php?f=5&t=58252
;http://forums.purebasic.com/english/viewtopic.php?t=12149
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 114
; FirstLine = 94
; Folding = -
; Executable = persistor.exe
; EnablePurifier
; IncludeVersionInfo
; VersionField0 = 1.0.0.0
; VersionField1 = 1.0.0.0
; VersionField2 = Shiltimur Inc.
; VersionField3 = Shiltimur Persistor
; VersionField4 = 1.0.0.0
; VersionField5 = 1.0.0.0
; VersionField6 = Realtime persistence helper for Shiltimur
; VersionField7 = Persistor
; VersionField8 = Persistor