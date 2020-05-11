;date and time utility include file
EnableExplicit

Procedure.s GetDateTime()
  Define date
  Define.s year_,month_,day_,dayname_,hour_,minute_,second_
  Define.s date_,time_
  
  date=Date()
  
  year_=Str(Year(date))
  
  Select Month(date)
    Case 1
      month_="Jan"
    Case 2
      month_="Feb"
    Case 3
      month_="Mar"
    Case 4
      month_="Apr"
    Case 5
      month_="May"
    Case 6
      month_="Jun"
    Case 7
      month_="Jul"
    Case 8
      month_="Aug"
    Case 9
      month_="Sep"
    Case 10
      month_="Oct"
    Case 11
      month_="Nov"
    Case 12
      month_="Dec"
  EndSelect
  
  day_=Str(Day(date))
  
  Select DayOfWeek(date)
    Case 0
      dayname_="Sun"
    Case 1
      dayname_="Mon"
    Case 2
      dayname_="Tue"
    Case 3
      dayname_="Wed"
    Case 4
      dayname_="Thu"
    Case 5
      dayname_="Fri"
    Case 6
      dayname_="Sat"
  EndSelect
  
  
  If Mod(Hour(date),12)<>0
    hour_=Str(Mod(Hour(date),12))
  Else
    hour_="12"
  EndIf
      
  
  minute_=Str(Minute(date))
  
  second_=Str(Second(date))
  
  If Hour(date)<12
    time_=hour_+":"+minute_+":"+second_+" AM"
  Else
    time_=hour_+":"+minute_+":"+second_+" PM"
  EndIf
  
  date_=month_+" "+day_+", "+year_
  
  ProcedureReturn time_+" | "+date_
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 3
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier