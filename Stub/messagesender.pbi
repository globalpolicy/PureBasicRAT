;include file for sending message/file to the Telegram bot
XIncludeFile "configreader.pbi"
XIncludeFile "randomgen.pbi"

EnableExplicit

Procedure MessageSendText(msg.s, chatId.q, replyToMessageId.q=0)
  Define request,url.s,header,jsonBody,jsonBodyString.s
  Define tmp,tmp1,statuscode.s
  
  url=getApiURL()+"sendMessage"
  
  ;construction of JSON
  jsonBody=CreateJSON(#PB_Any)
  tmp=SetJSONObject(JSONValue(jsonBody))
  
  tmp1=AddJSONMember(tmp,"chat_id")
  SetJSONQuad(tmp1,chatId)
  
  tmp1=AddJSONMember(tmp,"text")
  SetJSONString(tmp1,msg)
  
  If replyToMessageId ;if reply flag enabled
    tmp1=AddJSONMember(tmp,"reply_to_message_id")
    SetJSONQuad(tmp1,replyToMessageId)
  EndIf
  ;construction of JSON finished
  
  jsonBodyString=ComposeJSON(jsonBody,#PB_JSON_PrettyPrint) ;convert the constructed JSON to string
  
  InitNetwork()
  NewMap header.s()
  header("Content-Type")="application/json"
  request=HTTPRequest(#PB_HTTP_Post,url,jsonBodyString,0,header()) ;synchronous
  statuscode=HTTPInfo(request,#PB_HTTP_StatusCode) ;should be 200 for OK
    
  FinishHTTP(request)
EndProcedure

Procedure MessageSendFile(filePath.s, chatId.q, replyToMessageId.q=0, isPhoto.i=#False)
  Define file,filelength.q,*mem,readBytes.q,fileContentsString.s
  Define request,url.s,textBody.s,closingDelim.s,contentLength.q,response.s
  Define fileType.s,delim.s
  delim=GetRandomString(24) ;24-character random string
  closingDelim=#CRLF$+"--"+delim+"--"
  
  filelength=FileSize(filepath)
  If filelength<0
    MessageSendText("File doesn't exist!",chatId,replyToMessageId)  
    ProcedureReturn
  EndIf
  
  *mem=AllocateMemory(filelength+2048) ;filelength plus the multipart info(asumed 2KB)
  
  textBody="--"+delim+#CRLF$+
           "Content-Disposition: form-data; name="+#DQUOTE$+"chat_id"+#DQUOTE$+#CRLF$+#CRLF$+
           Str(chatId)+#CRLF$
  If replyToMessageId
    textBody=textBody+
             "--"+delim+#CRLF$+
             "Content-Disposition: form-data; name="+#DQUOTE$+"reply_to_message_id"+#DQUOTE$+#CRLF$+#CRLF$+
             Str(replyToMessageId)+#CRLF$
  EndIf
  If isPhoto
    fileType="photo"
  Else
    fileType="document"
  EndIf 
  textBody=textBody+
         "--"+delim+#CRLF$+
         "Content-Disposition: form-data; name="+#DQUOTE$+fileType+#DQUOTE$+"; filename="+#DQUOTE$+ExtractFilename(filePath)+#DQUOTE$+ ;"filename" field seems to be required
         #CRLF$+#CRLF$ ;append the binary data of file here
  
  PokeS(*mem,textBody,-1,#PB_Ascii) ;PB uses unicode by default. need ascii strings for HTTP.
  
  file=OpenFile(#PB_Any,filePath,#PB_File_SharedRead)
  
  readBytes=ReadData(file,*mem+Len(textBody),filelength) ;read into after the text body
  
  CloseFile(file)
  
  If readBytes=filelength
    
    PokeS(*mem+Len(textBody)+filelength,closingDelim,-1,#PB_Ascii) ;add the closing delim text to the body.
    
    contentLength=Len(textBody)+filelength+Len(closingDelim)
       
    NewMap header$()
    header$("Content-Type")="multipart/form-data; boundary="+delim
    header$("Content-Length")=Str(contentLength)
    
    url= getApiURL()+"send"+fileType
    
    InitNetwork()

    request=HTTPRequestMemory(#PB_HTTP_Post,url,*mem,contentLength,0,header$())
    
    If request
      response=HTTPInfo(request,#PB_HTTP_Response)
      FinishHTTP(request)  
    EndIf
    
    
    

  EndIf
  
  
EndProcedure

Procedure SetAvailableBotCommands()
  ;sets commands specified as JSON in the file "commands.inc" to the bot
  
  Define dataBody.s,url.s
  Define request,status.s
  NewMap headers.s()
  
  dataBody=PeekS(?location,-1,#PB_Ascii)
  headers("Content-Length")=Str(Len(dataBody))
  headers("Content-Type")="application/json"
  url=getApiURL()+"setmycommands"
  InitNetwork()
  request=HTTPRequest(#PB_HTTP_Post,url,dataBody,0,headers())
  If request
    status=HTTPInfo(request,#PB_HTTP_Response)
    FinishHTTP(request)
  EndIf


  DataSection
    location:
    IncludeBinary "commands.inc"
  EndDataSection
  
EndProcedure

;references
;https://medium.com/@danishkhan.jamia/upload-data-using-multipart-16b54866f5bf
;https://www.purebasic.fr/english/viewtopic.php?f=13&t=58243 =>combining binary data and text data for HTTP POST request to upload file
;http://ptsv2.com-->POST test server
;https://stackoverflow.com/questions/7553005/sending-a-file-via-post-using-raw-http-putty
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 136
; FirstLine = 112
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier