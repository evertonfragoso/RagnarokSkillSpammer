#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance


if (!JEE_AhkIsAdmin()) {
	MsgBox, You need to run as Admin!
	ExitApp
}


Gui, Font, s11, Arial
Gui, Font, s11, Tahoma  ; Preferred font.

Gui, Show, x400 y300 h240 w490, RO Skill Spammer ; Window title


; TODO: implement "," (comma) and "." (period) keys
allKeys := ["F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9"
			,"1", "2", "3", "4", "5", "6", "7", "8", "9"
			,"Q", "W", "E", "R", "T", "Y", "U", "I", "O"
			,"A", "S", "D", "F", "G", "H", "J", "K", "L"
			,"Z", "X", "C", "V", "B", "N", "M"] ;, ",", "."]


functionKeysList := allKeys.Clone()
functionKeysList.RemoveAt(10, allKeys.Length())

numberKeysList := allKeys.Clone()
numberKeysList.RemoveAt(19, numberKeysList.Length())
numberKeysList.RemoveAt(0, 10)

firstRowKeysList := allKeys.Clone()
firstRowKeysList.RemoveAt(28, firstRowKeysList.Length())
firstRowKeysList.RemoveAt(0, 19)

secondRowKeysList := allKeys.Clone()
secondRowKeysList.RemoveAt(37, secondRowKeysList.Length())
secondRowKeysList.RemoveAt(0, 28)

thirdRowKeysList := allKeys.Clone()
thirdRowKeysList.RemoveAt(0, 37)


startX := 20
startY := 25

Gui, Add, GroupBox, x10 y5 w470 h50 , Function Keys

For Key, Value in functionKeysList {
	Gui, Add, CheckBox, x%startX% y%startY% w50 h25 v%Value%ClickStatus gSubmitClickStatus, %Value%
	startX := startX + 50
}

Gui, Add, GroupBox, x10 y60 w470 h160 , Alphanumeric

startX := 20
startY := 85

For Key, Value in numberKeysList {
	Gui, Add, CheckBox, x%startX% y%startY% w50 h25 v%Value%ClickStatus gSubmitClickStatus, %Value%
	startX := startX + 50
}

startX := 20
startY := 120

For Key, Value in firstRowKeysList {
	Gui, Add, CheckBox, x%startX% y%startY% w50 h25 v%Value%ClickStatus gSubmitClickStatus, %Value%
	startX := startX + 50
}

startX := 20
startY := 155

For Key, Value in secondRowKeysList {
	Gui, Add, CheckBox, x%startX% y%startY% w50 h25 v%Value%ClickStatus gSubmitClickStatus, %Value%
	startX := startX + 50
}

startX := 20
startY := 190

For Key, Value in thirdRowKeysList {
	Gui, Add, CheckBox, x%startX% y%startY% w50 h25 v%Value%ClickStatus gSubmitClickStatus, %Value%
	startX := startX + 50
}


Gui, Font, s9,
Gui, Add, Link, x450 y220 w50 h20 , <a href="https://github.com/evertonfragoso/RagnarokSkillSpammer">v2.0a</a>
Gui, Font, s11,

Gui, Submit, NoHide
gosub, updateKeys

Menu, Tray, Add, Restore, Restore
Menu, Tray, default, Restore
Menu, Tray, Click, 2
return

SubmitClickStatus:
	Gui, Submit, NoHide
	gosub, updateKeys
return

updateKeys:
{
	For key, value in allKeys {
		hotkey, %value%, spam
	}
}
return

spam:
{
	; TODO: implement optional/toggleable mouse click
	#If WinActive("ahk_class Ragnarok")
		OutputDebug, %a_thishotkey%
		while getkeystate(a_thishotkey, "p") {
				ControlSend, ahk_parent, {%a_thishotkey%}, ahk_class Ragnarok
				if (%a_thishotkey%ClickStatus == true)
					ControlClick,, ahk_class Ragnarok
				Sleep, 10
		}
}
return
	
;==================================================

JEE_AhkIsAdmin()
{
	;see AHK source code: os_version.h
	;see also:
	;Operating System Version (Windows)
	;https://msdn.microsoft.com/en-gb/library/windows/desktop/ms724832(v=vs.85).aspx
	;Using the Windows Headers (Windows)
	;https://msdn.microsoft.com/en-us/library/windows/desktop/aa383745(v=vs.85).aspx
	vVersion := DllCall("kernel32\GetVersion", "UInt")
	if (vVersion & 0xFF < 5)
		return 1

	;SC_MANAGER_LOCK := 0x8
	hSC := DllCall("advapi32\OpenSCManager", "Ptr",0, "Ptr",0, "UInt",0x8, "Ptr")
	vRet := 0
	if hSC
	{
		if (vLock := DllCall("advapi32\LockServiceDatabase", "Ptr",hSC, "Ptr"))
		{
			DllCall("advapi32\UnlockServiceDatabase", "Ptr",vLock)
			vRet := 1
		}
		else
		{
			vLastError := DllCall("kernel32\GetLastError", "UInt")
			;ERROR_SERVICE_DATABASE_LOCKED := 1055
			if (vLastError = 1055)
				vRet := 1
		}
		DllCall("advapi32\CloseServiceHandle", "Ptr", hSC)
	}
	return vRet
}
;==============================

GuiSize:
  if (A_EventInfo = 1)
    WinHide
  return

Restore:
  gui +lastfound
  WinShow
  WinRestore
  return

GuiClose:
	ExitApp
