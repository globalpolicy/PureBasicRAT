;resource writer/reader include file
XIncludeFile "xor.pbi"

EnableExplicit

Procedure.i WriteStringToResource(exeFilePath.s,string.s,resType.s="sometype",resName.s="somename",isUnicodeString.i=#True)
  Define resourceHandle.i,error.i,cbData.i,retval.i
  Define *encrypted
  retval=#False
  
  If isUnicodeString
    cbData=Len(string)*2
  Else
    cbData=Len(string)
  EndIf
  
  *encrypted=XorCrypt(@string,cbData,"totallynotakey")  
  
  ;if this function is called back to back, some antivirus softwares briefly jam up the handle to the exeFilePath which can 
  Delay(100) ;cause the EndUpdateResource_() To fail. adding this delay allows the antivirus to complete whatever it does and
  ;leave the file specified by exeFilePath be.
  
  resourceHandle=BeginUpdateResource_(exeFilePath,#False)
  If resourceHandle
    If UpdateResource_(resourceHandle,resType,resName,0,*encrypted,cbData)
      retry:
      If EndUpdateResource_(resourceHandle,#False)
        retval= #True
      Else
        error=GetLastError_()
      EndIf
    Else
      error=GetLastError_()
    EndIf
  EndIf
  
  If error>0:Debug error:EndIf
  ProcedureReturn retval
EndProcedure


;references
;https://www.codeproject.com/Articles/4945/UpdateResource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-sizeofresource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-lockresource
;https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadresource
;https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-beginupdateresourcea
;https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-updateresourcea
;https://docs.microsoft.com/en-us/windows/win32/menurc/using-resources
;http://www.cplusplus.com/forum/general/9700/
;https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-
;https://github.com/dotnet/runtime/issues/3832
;https://stackoverflow.com/questions/14378769/updateresource-no-error-but-resource-not-added-why
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier