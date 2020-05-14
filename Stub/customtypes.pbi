;custom types include file
EnableExplicit

Structure TelegramMessage
  UpdateId.q
  Date.q
  FromId.q
  FirstName.s
  IsBot.l
  MessageId.q
  Text.s
EndStructure

Structure MessageboxParams
  title.s
  text.s
EndStructure

Structure TelegramCommandArrayHolder ;this structure is just for passing to thread procedure since passing an array directly doesn't seem to work
  Array commandArray.TelegramMessage(0)  
EndStructure

Structure MouseClickInfo
  numTimes.i
  interval.i
  mouseButton.s
EndStructure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 15
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier