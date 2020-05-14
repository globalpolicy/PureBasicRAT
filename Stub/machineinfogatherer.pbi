;include file containing procedures for gathering information about the computer
XIncludeFile "hasher.pbi"

EnableExplicit

Prototype GetNativeSystemInfo(*systemInfo.SYSTEM_INFO)
Global GetNativeSystemInfo_.GetNativeSystemInfo=GetFunction(OpenLibrary(#PB_Any,"kernel32.dll"),"GetNativeSystemInfo")

Procedure.i IsWindows64Bit()
  Define info.SYSTEM_INFO
  GetNativeSystemInfo_(@info)
  If info\wProcessorArchitecture=9 ;https://docs.microsoft.com/en-us/windows/win32/api/sysinfoapi/ns-sysinfoapi-system_info
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure


Procedure.s GetHardwareId()
  ;reference: https://stackoverflow.com/a/8072470/7647225
  Define processorInfoFromEnv.s,systemInfo.s,comboString.s,hash.l
  processorInfoFromEnv=GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")+GetEnvironmentVariable("PROCESSOR_IDENTIFIER")+
                       GetEnvironmentVariable("PROCESSOR_LEVEL")+GetEnvironmentVariable("PROCESSOR_REVISION")
  systemInfo=CPUName()+CountCPUs(#PB_System_CPUs)+Str(MemoryStatus(#PB_System_TotalPhysical))+Str(OSVersion())
  comboString=processorInfoFromEnv+systemInfo
  hash=MurmurHash3(@comboString,Len(comboString))
  ProcedureReturn Str(hash)
EndProcedure

Procedure.s GetMachineInfo()
  Define OS.s,output.s
  output="Computer name: "+ComputerName()+#LF$+
         "User name: "+UserName()+#LF$+
          "CPU: "+CPUName()+#LF$+
         "Cores: "+CountCPUs(#PB_System_CPUs)+#LF$+
         "Memory: "+Str(MemoryStatus(#PB_System_TotalPhysical)/(1024*1024))+" MB"+#LF$+
         "OS: "
  Select OSVersion()
    Case #PB_OS_Windows_10
      os="Windows 10"
    Case #PB_OS_Windows_8_1
      os="Windows 8.1"
    Case #PB_OS_Windows_8
      os="Windows 8"
    Case #PB_OS_Windows_7
      os="Windows 7"
    Case #PB_OS_Windows_Vista
      os="Windows Vista"
    Case #PB_OS_Windows_XP
      os="Windows XP"
    Case #PB_OS_Windows_2000
      os="Windows 2000"
    Case #PB_OS_Windows_98
      os="Windows 98"
    Case #PB_OS_Windows_95
      os="Windows 95"
    Case #PB_OS_Windows_Server_2003
      os="Windows Server 2003"
    Case #PB_OS_Windows_Server_2008
      os="Windows Server 2008"
    Case #PB_OS_Windows_Server_2008_R2
      os="Windows Server 2008 R2"
    Case #PB_OS_Windows_Server_2012
      os="Windows Server 2012"
    Case #PB_OS_Windows_Server_2012_R2
      os="Windows Server 2012 R2"
    Case #PB_OS_Windows_Future
      os="Unknown Windows 10+"
    Default
      os="Unknown Windows OS"
  EndSelect
  output=output+os+#LF$+
         "ID: "+GetHardwareId()
  ProcedureReturn output
EndProcedure



; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 15
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; EnablePurifier