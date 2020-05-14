;keypresser include file
EnableExplicit

Procedure TypeThis(toType.s)
  Define  i.i,j.i
  
  Define input.INPUT
  Dim inputs.INPUT(0)
  
  Define char.c
  Define vkCode.c
  Define shiftState.c=#False ;to be used as boolean
  
  For i=0 To Len(toType)-1
    char=PeekC(@toType+i*SizeOf(character))
    vkCode=VkKeyScan_(char) & $00FF ;lower order byte
    shiftState=(VkKeyScan_(char) >> 8) & $00FF ;higher order byte. ref. https://stackoverflow.com/a/6090641/7647225
    If shiftState & 1 = 1 ;ref. Result section @ https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-vkkeyscana
      shiftState=#True ;shift is to be pressed
    Else
      shiftState=#False
    EndIf
    
    If shiftState
      ReDim inputs(j)
      inputs(j)\type=#INPUT_KEYBOARD
      inputs(j)\ki\wVk=#VK_SHIFT
      j=j+1  
    EndIf
    
    ReDim inputs(j)
    inputs(j)\type=#INPUT_KEYBOARD
    inputs(j)\ki\wVk=vkCode
    j=j+1
    
    ReDim inputs(j)
    inputs(j)\type=#INPUT_KEYBOARD
    inputs(j)\ki\wVk=vkCode
    inputs(j)\ki\dwFlags=#KEYEVENTF_KEYUP
    j=j+1
    
    If shiftState
      ReDim inputs(j)
      inputs(j)\type=#INPUT_KEYBOARD
      inputs(j)\ki\wVk=#VK_SHIFT
      inputs(j)\ki\dwFlags=#KEYEVENTF_KEYUP
      j=j+1
    EndIf
  Next i
  
  SendInput_(ArraySize(inputs())+1,inputs(),SizeOf(input))
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 47
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier