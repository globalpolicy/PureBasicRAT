;gets commands using Telegram Bot API
XIncludeFile "configreader.pbi"
XIncludeFile "customtypes.pbi"
XIncludeFile "logger.pbi"

EnableExplicit


Procedure ThreadProc(*messages.TelegramCommandArrayHolder)
  Dim *messages\commandArray(0) ;reset the input array so that an empty array is returned if failed to retrieve new commands
  
  Define reqURL.s,request.l,*received,responseBody.s
  Define json.l,jsonObject,okStatus.i,resultArray,i.i,result,updateId.q,message,messageId.q,from,fromId.q,firstName.s,isBot.l,date.q,text.s  
  
  InitNetwork()
  reqURL=getApiURL()+"getUpdates?offset="+Str(getLastUpdateId()+1)
  request.l=HTTPRequest(#PB_HTTP_Get,reqURL)
  If request
    *received=HTTPMemory(request)
    FinishHTTP(request)
    If *received
      responseBody=PeekS(*received,MemorySize(*received),#PB_UTF8)
      FreeMemory(*received)
      ;Debug responseBody
      json=ParseJSON(#PB_Any,responseBody,#PB_JSON_NoCase)
      If json
        jsonObject=JSONValue(json)
        okStatus=GetJSONBoolean( GetJSONMember(jsonObject,"ok"))
        If okStatus
          resultArray= GetJSONMember(jsonObject,"result")
          For i=0 To JSONArraySize(resultArray)-1 ;json array is 0-indexed
            result=GetJSONElement(resultArray,i)  
            updateId=GetJSONQuad( GetJSONMember(result,"update_id"))
            saveUpdateId(updateId)
            message=GetJSONMember(result,"message")
            If message 
              messageId=GetJSONQuad(GetJSONMember(message,"message_id"))
              from=GetJSONMember(message,"from")
              fromId=GetJSONQuad(GetJSONMember(from,"id"))
              firstName=GetJSONString(GetJSONMember(from,"first_name"))
              isBot=GetJSONBoolean(GetJSONMember(from,"is_bot"))
              date=GetJSONQuad(GetJSONMember(message,"date"))
              text=GetJSONString(GetJSONMember(message,"text"))
              ;Debug updateId
              
              ReDim *messages\commandArray(i+1) ;this array's index starts from 1. i.e. *messages\commandArray is assumed 1-indexed. this allows checking for array emptiness
              *messages\commandArray(i+1)\UpdateId=updateId
              *messages\commandArray(i+1)\Date=date
              *messages\commandArray(i+1)\FromId=fromId
              *messages\commandArray(i+1)\FirstName=firstName
              *messages\commandArray(i+1)\IsBot=isBot
              *messages\commandArray(i+1)\MessageId=messageId
              *messages\commandArray(i+1)\Text=text
            EndIf
          Next
        EndIf
      EndIf
    EndIf
  EndIf  
EndProcedure


Procedure RetrieveCommandArray(*commandsHolder.TelegramCommandArrayHolder, timeoutMs.i) ;syntax while passing an array, must specify the array dimension i.e. 1 here
                                                                  ;fills the commandsHolder\commandArray parameter for the output
                                                                  ;commandsHolder\commandArray will be returned as a 1-indexed array
                                                                  ;waits for a max of timeoutMs before returning. HTTPRequest can hang sometimes, that's why.
  Define thread.i
  thread=CreateThread(@ThreadProc(),*commandsHolder)
  WaitThread(thread,timeoutMs)
  If IsThread(thread) ;thread is stuck, most likely at the HTTPRequest function
    LogMsg("Command retriever thread stuck!")
    KillThread(thread)
  EndIf
  
EndProcedure

;references. i've come to realise this is a good practice for my puzzled self-reflecting future self
;PeekS(*received,MemorySize(*received),#PB_UTF8)->https://www.purebasic.fr/english/viewtopic.php?f=4&t=72637



; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 69
; FirstLine = 52
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier