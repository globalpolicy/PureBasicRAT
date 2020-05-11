;apparently, .pbi files are 'include files' by convention. 
;they _can_ execute standalone but are generally assumed to house support code and modules


DeclareModule Screenshotter
  EnableExplicit
  Declare SaveScreenshotPNG(filename.s)
EndDeclareModule

Module Screenshotter
  ;https://docs.microsoft.com/en-us/windows/win32/gdi/capturing-an-image   
  Procedure SaveScreenshotPNG(filename.s)
    Define width.l,height.l,hdcSrc.l,hdcNew.l, bitmapHandle.l, image.l, selectRet.l, error.l
    width=GetSystemMetrics_(#SM_CXSCREEN)
    height=GetSystemMetrics_(#SM_CYSCREEN)
    hdcSrc=GetDC_(0)
    hdcNew=CreateCompatibleDC_(hdcSrc)
    bitmapHandle= CreateCompatibleBitmap_(hdcSrc,width,height)
    selectRet=SelectObject_(hdcNew,bitmapHandle)
    BitBlt_(hdcNew,0,0,width,height,hdcSrc,0,0,#SRCCOPY)
    ReleaseDC_(0,hdcSrc)
    DeleteDC_(hdcNew)
    image=CreateImage(#PB_Any,width,height)
    StartDrawing(ImageOutput(image))
    DrawImage(bitmapHandle,0,0)
    StopDrawing()
    UseJPEGImageEncoder()
    SaveImage(image,filename,#PB_ImagePlugin_JPEG)  
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
    Screenshotter::SaveScreenshotPNG("saved.jpeg")
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 32
; Folding = -
; EnableAsm
; EnableThread
; EnableXP
; Executable = output.exe
; EnablePurifier