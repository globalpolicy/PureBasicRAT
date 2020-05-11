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

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 15
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier