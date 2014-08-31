#SingleInstance force
; #NoEnv
#Hotstring B0
#Hotstring EndChars : 
DetectHiddenWindows, on
DetectHiddenText, On
HIDEcount = 0
; #NoTrayIcon

SendMode Input
; SetWorkingDir %A_ScriptDir%
; SetWorkingDir %A_Temp%
SetWorkingDir %A_WinDir%A_Programs
SetTitleMatchMode, 2
SetTitleMatchMode, slow
OnExit, DeWonk


:*:clip:plot::
FileDelete, %A_Temp%\plotty.txt
Loop, Parse, Clipboard,`n
{
Plot%A_Index% := A_LoopField
}

text := "plot([" . Plot1 . "], [" . Plot2 . "], '^');`npause;"

FileAppend,%text%,%A_Temp%\plotty.txt
Run, C:\Octave\3.2.4_gcc-4.4.0\bin\Octave "%A_Temp%\plotty.txt"
return


:*:clip:histo::
FileDelete, %A_Temp%\plotty.txt
Loop, Parse, Clipboard,`n
{
Plot%A_Index% := A_LoopField
}
text := "hist([" . Plot1 . "]);`npause;"
FileAppend,%text%,%A_Temp%\plotty.txt
Run, C:\Octave\3.2.4_gcc-4.4.0\bin\Octave "%A_Temp%\plotty.txt"
return


^`::
WinSet, AlwaysOnTop, on, A
WinSet, Transparent, 200, A
return

^!`::
WinSet, AlwaysOnTop, off, A
WinSet, Transparent, 255, A
return

::gclip::
Loop, Parse, Clipboard,`t`n`r|
{
	if A_LoopField in `t,`n,`r
		continue
	else Run, http://www.google.com/search?hl=en&q=%A_LoopField%
; &tbm=shop
}
return

:*:write:a::
WinActivate,Notepad
return

:B*:write:h::
WinActivate,Notepad
WinHide,NotePad
return

:*:write:s::
IfWinActive,NotePad
  Send, {Backspace 7}
WinShow,NotePad
WinActivate,NotePad
return

/*
THIS IS THE BASIS OF THE HAM.RUN COMMAND!

::ham.run::
Input, IN, T45,{Enter}
if IN =
	return
Run,%IN%,,UseErrorLevel
if ErrorLevel != ERROR
	return
IN := SearchDir(IN,"exe")
If IN =
	{
	MsgBox Oops! That application does not exist.
	return
	}
else
	{	
	Run,%IN%,,UseErrorLevel
		if ErrorLevel = ERROR
	Run, properties %IN%,,UseErrorLevel
	if ErrorLevel = ERROR
		Msgbox Well THAT didn't work!
	}
return
*/



/*
THIS IS THE BASIS OF THE HAM.OPEN COMMAND!

::ham.run::
Input, IN, T45,{Enter}
if IN =
	return
IN := SearchDir(IN)
If IN = ERROR
	{
	MsgBox Oops! That application does not exist.
	return
	}
else
	{
	Run,%IN%,,UseErrorLevel
		if ErrorLevel = ERROR
	Run, properties %IN%,,UseErrorLevel
	if ErrorLevel = ERROR
		Msgbox Well THAT didn't work!
	}
return
*/

::ham.web::
Input, IN, T45,{Enter}
Loop, Parse, IN,`;
	Run, http://%A_LoopField%
return

::ham.google::
Input, IN, T45,{Enter}
Loop, Parse, IN,`;
	Run, http://www.google.com/search?hl=en&q=%A_LoopField%&btnG=Search
return


::ham.youtube:: 
Input, IN, T45,{Enter}
Run, http://www.youtube.com/results?search_query=%IN%
return

::ham.ahk::
Input, IN, T45,{Enter}
Run, http://www.autohotkey.com/search/search.php?query_string=%IN%
return

::ham.wiki::
Input, IN, T45,{Enter}
Loop, Parse, IN,`;
	Run, http://en.wikipedia.org/w/index.php?search=%A_LoopField%
return

:*:win:kill::
WinKill, A
return


:*:win:min::
Winminimize, A
return

:*:win:h::
HIDEcount++
WinGet, HIDDENWIN, ID, A
WinHide, ahk_id %HIDDENWIN%
HIDE%HIDEcount% := HIDDENWIN
HIDDENWIN =
return

:*:win:sh::
if HIDEcount > 0
	{
	HIDDENWIN := HIDE%HIDEcount%
	HIDEcount--
	WinShow, ahk_id %HIDDENWIN%
	WinActivate, ahk_id %HIDDENWIN%
	HIDDENWIN = 
	}
else Msgbox Whutchoo Talkin' About Willis?
return

:*:win:allsh::
Loop %HIDEcount%
  {
  element := HIDE%A_Index%
  WinShow, ahk_id %element%
  WinActivate, ahk_id %element%
  }
HIDEcount := 0
return 

:*:win:cnt::
msgbox % HIDEcount
return

^!+Space::ExitApp


:*:app:edit::
Run, edit %A_ScriptFullPath%
return

:*:app:test::
MsgBox :P
Return

:B*:app:re::
Reload
return 

DeWonk:
Loop % HIDEcount + 1
  {
  element := HIDE%A_Index%
  WinShow, ahk_id %element%
  WinActivate, ahk_id %element%
  }
WinShow, ahk_class Shell_TrayWnd
WinShow,WordPad
; BlockInput, MouseMoveOff ; I don't use this nemore
ExitApp




/*
INSERT THE BASIS OF THE SEARCHDIR FUNCTION

SearchDir(STR,EXTLIST = "",PATHLIST = A_ScriptDir)
{
	if (STR = "")
		return "ERROR"
	if PATHLIST = ""
		return "ERROR"
	Critical 
	MATCH = 0
	RETURNvar =
	Loop, parse, PATHLIST,|
	{
		Loop, %A_LoopField%\*.*, 1, 1
		; Note: This assumes that the \ at the end is left off.
		; May have to test that before putting the var in, or vice versa
		{
			if A_LoopFileAttrib contains R,S,H,T
	   			continue
			else  
			{
				IfInString, A_LoopFileName, %STR%
				{
					if EXTLIST !=
	        			{	
						if A_LoopFileExt not in %EXTLIST%
					                continue
				        }
	
				; eliminates non-listed extensions if extensions are listed
				return A_LoopFileFullPath
	    			}
			}
	   	}
	}
	Critical, OFF
	return "ERROR"
}
*/