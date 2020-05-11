;resource reader include file
XIncludeFile "xor.pbi"

EnableExplicit

Procedure.s Decrypt(*input,inputsize.i,key.s)
  Define *decrypted,decryptedString.s
  *decrypted=XorCrypt(*input,inputsize,key)
  decryptedString=PeekS(*decrypted,inputsize)
  ProcedureReturn decryptedString
EndProcedure


Procedure.s ReadStringFromResource(exeFilePath.s,key.s,resType.s="sometype",resName.s="somename",isUnicode.i=#True)
  Define resourceHandle.i,error.i,dataHandle.i,resourceSize.i,*resourceData,resourceAsString.s
  resourceHandle=FindResource_(LoadLibrary_(exeFilePath),resName,resType)
  If resourceHandle
    dataHandle=LoadResource_(LoadLibrary_(exeFilePath),resourceHandle)
    If dataHandle
      resourceSize=SizeofResource_(LoadLibrary_(exeFilePath),resourceHandle) ;returns total number of bytes in the resource
      If isUnicode
        resourceAsString=Space(resourceSize/2) ;length of unicode string=num of bytes/2
      Else
        resourceAsString=Space(resourceSize) ;length of ascii string=num of bytes
      EndIf
      If resourceSize
        *resourceData=LockResource_(dataHandle)
        If *resourceData
          resourceAsString=Decrypt(*resourceData,resourceSize,key)
          ProcedureReturn resourceAsString
        Else
          Debug "Cannot lock resource"
        EndIf  
      Else
        error=GetLastError_()
      EndIf
    Else
      error=GetLastError_()
    EndIf
    
  EndIf  
EndProcedure


;references
;https://www.codeproject.com/Articles/4945/UpdateResource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-sizeofresource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-lockresource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadresource
;https://docs.microsoft.com/en-us/windows/win32/menurc/using-resources
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 13
; FirstLine = 9
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier