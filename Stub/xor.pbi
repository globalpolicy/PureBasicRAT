EnableExplicit

Procedure.i XorCrypt(*inBuffer, numBytes.i, key.s, isKeyUnicode.i=#True)
  ;remember, key is supposed to be a string(both ASCII and Unicode supported). so no extraneous null bytes expected in key.
  ;returns the address of encrypted buffer. number of bytes is preserved i.e. number of bytes of input = number of bytes of output
  Define i.i, j.i, dataByte.b, keyByte.b, *outBuffer
  Define outByte.b
  
  *outBuffer=AllocateMemory(numBytes)
  
  For i=0 To numBytes-1
    dataByte=PeekB(*inBuffer+i) ;read one byte from input
    keyByte=PeekB(@key+j)       ;read one byte from key string
    If keyByte=0 ;if null byte encountered, reached end of key string
      j=0        ;reset key byte counter to 0  
      keyByte=PeekB(@key) ;read first byte of key string
    EndIf
    If isKeyUnicode
      j=j+2
    Else
      j=j+1
    EndIf

    outByte=dataByte ! keyByte
    PokeB(*outBuffer+i,outByte) ;write one byte to output buffer
  Next i
  
  ProcedureReturn *outBuffer
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Define somestring.s, *encrypted, *decrypted, decryptedString.s
  somestring="somestringtobeencrypted"
  *encrypted=XorCrypt(@somestring,Len(somestring)*2,"somekey")
  *decrypted=xorcrypt(*encrypted,Len(somestring)*2,"somekey")
  decryptedString=PeekS(*decrypted,Len(somestring)) ;specifying length is important else a couple of gibberish characters maybe appended to the output string
  Debug decryptedString
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 32
; FirstLine = 10
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier