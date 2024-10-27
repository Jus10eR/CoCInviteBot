#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <Misc.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include "COCButtonConstants.au3"

Opt("WinTitleMatchMode", 3)
Opt("MouseCoordMode", 0)
Opt("PixelCoordMode", 0)
Opt ('MouseClickDelay', '0')
Opt ('MouseClickDragDelay', '75')

$counterLine1=0
$profileNameLine2=""
$reloadlist=55				;How many plyers to Invite until the bot will reload the list
$backgroundcolor=0x36393F
$buttonbackgroundcolor=0x42464D
$white=0xFFFFFF
$red=0xFF0000
$fontcolor=$white
$guiWidth=328
$guiHeight=500
$windowWidth=898
$windowHeight=535
$dragstart=320	;Height from top to down in pixels where the bot starts dragging to the next player
$lastMousePos=MouseGetPos()
$filepath = "config.txt"					;Read the config file
$posConfigFilepath="PosConfig.txt"
$gotWindowHandle = false
$hwnd=Null
If Not FileExists($filepath) Then
				$config = FileOpen($filepath, 2)
				FileWrite($filepath, 0&@CRLF&"Clash of Clans"&@CRLF&88)
EndIf
$firstLine1 = FileReadLine($filepath, 1)
$profileNameLine2=FileReadLine($filepath, 2)
$dragrangeLine3=FileReadLine($filepath, 3)						;Amount of pixels the bot moves the mouse up after dragging
$counterLine1=$firstLine1


Local $hGUI = GUICreate("Clash of Clans Invite Bot", $guiWidth, $guiHeight, @DesktopWidth-$guiWidth, @DesktopHeight-$guiHeight-50, $WS_POPUPWINDOW)
GUISetFont("11", Default, Default, "Nirmala UI", $hGUI)
GUISetBkColor($backgroundcolor, $hGUI)

Local $idInputProfileName = GUICtrlCreateInput($profileNameLine2, 80, 390, 160, 25, $ES_CENTER+$ES_AUTOHSCROLL)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $backgroundcolor)
Local $cEnterPressed = GUICtrlCreateDummy()
Local $hInputProfileName = GUICtrlGetHandle($idInputProfileName)

Local $idButtonStart = GUICtrlCreateButton("Start", 60, 330, 200, 50, $BS_DEFPUSHBUTTON)
GuiCtrlSetFont(-1, 18)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

Local $idStaticProfileName = GUICtrlCreateLabel("ProfileName:", 0, 390, 78, 25, $SS_RIGHT)
GUICtrlSetColor(-1, $fontcolor)

Local $idButtonClose = GUICtrlCreateButton("✕", 293, 5, 30, 25)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $backgroundcolor)

Local $idStaticTitle = GUICtrlCreateLabel("Clash of Clans invite Bot", 20, 30, 288, 32, $SS_CENTER)
GuiCtrlSetFont(-1, 20, Default, 4)
GUICtrlSetColor(-1, $fontcolor)

Local $idStaticPlayersInvited = GUICtrlCreateLabel("Amount of Invited Players:", 20, 70, 250, 29)
GuiCtrlSetFont(-1, 15)
GUICtrlSetColor(-1, $fontcolor)

Local $idStaticAllTime = GUICtrlCreateLabel("All Time", 20, 140, 160)
GUICtrlSetFont(-1, 15)
GUICtrlSetColor(-1, $fontcolor)

Local $idVarInvitedPlayersAllTime = GUICtrlCreateLabel($counterLine1, 20, 104, 160, 35)
GUICtrlSetFont(-1, 17)
GUICtrlSetColor(-1, $fontcolor)

Local $idStaticThisSession = GUICtrlCreateLabel("This Session", 188, 140, 212)
GUICtrlSetFont(-1, 15)
GUICtrlSetColor(-1, $fontcolor)

Local $idVarInvitedPlayersSession = GuiCtrlCreateLabel($counterLine1-$firstLine1, 188, 104, 212, 35)
GUICtrlSetFont(-1, 17)
GUICtrlSetColor(-1, $fontcolor)

Local $idButtonResetAllTime = GUICtrlCreateButton("Reset All Time", 20, 174, 120, 40)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

Local $idButtonResetSession = GUICtrlCreateButton("Reset This Session", 188, 174, 120, 40)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

Local $idStaticSteps = GuiCtrlCreateLabel("Steps", 140, 240, -1, 20, $SS_CENTER)
GUICtrlSetColor(-1, $fontcolor)

Local $idInputPlusMinusStep = GUICtrlCreateInput(50, 140, 260, 40, 22, $ES_CENTER+$ES_NUMBER+$ES_AUTOHSCROLL)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $backgroundcolor)

Local $idButtonMinus = GUICtrlCreateButton("-", 95, 240, 40, 40)
GUICtrlSetFont(-1, 17)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

Local $idButtonPlus = GUICtrlCreateButton("+", 185, 240, 40, 40)
GUICtrlSetFont(-1, 17)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

Local $idStaticPlayersToInvite = GUICtrlCreateLabel("Invites"&@CRLF&"left:" , 10, 280, 45, 50, $SS_RIGHT)
GUICtrlSetColor(-1, $fontcolor)

Local $idInputPayersToInvite = GUICtrlCreateInput("∞", 60, 290, 200, 25, $ES_CENTER+$ES_NUMBER+$ES_AUTOHSCROLL)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $backgroundcolor)

Local $idStaticDragRange = GUICtrlCreateLabel("Dragrange:", 0, 420, 78, 25, $SS_RIGHT)
GUICtrlSetColor(-1, $fontcolor)

Local $idInputDragRange = GUICtrlCreateInput($dragrangeLine3, 80, 420, 160, 25, $ES_CENTER+$ES_AUTOHSCROLL+$ES_NUMBER)
GUICtrlSetColor(-1, $fontcolor)
GUICtrlSetBkColor(-1, $backgroundcolor)

Local $idButtonResetButtonPos = GUICtrlCreateButton("Reset All Button Positions", 70, 455, 180, 30)
GUICtrlSetColor(-1, $red)
GUICtrlSetBkColor(-1, $buttonbackgroundcolor)

GUICtrlSetResizing($idButtonStart, 8)
GUICtrlSetResizing($idStaticSteps, 8)

GuiSetState(@SW_SHOW, $hGUI)

Global $aAccelKeys[][2] = [["{ENTER}", $cEnterPressed]]
GUISetAccelerators($aAccelKeys)


main()
Func main()
	$firstRound = True
		Do
				$profileNameLine2=FileReadLine($filepath, 2)
				$hwnd = WinGetHandle ($profileNameLine2) ; Get The Handle
				if Not @error Then
					$gotWindowHandle = True
					Global $lastMousePos=MouseGetPos()															;Check that the LDPlayer toolbar is closed
					WinActivate($hwnd)
				MouseMove($lastMousePos[0], $lastMousePos[1], 0)
				EndIf
		Until $profileNameLine2<>""
	GuiCtrlSetFont($idButtonStart, 18)
	GUICtrlSetData($idButtonStart, "Start")
	GUICtrlSetState($idButtonStart, $GUI_ENABLE)
	WinMove($hGUI, "", $windowWidth, 0)

	While(1)
		if IsHWnd($hwnd) And $firstRound == True Then
			WinGetPos($hwnd)
			if Not @error Then
			WinActivate($hwnd)
			Do
				WinMove($hwnd, "", 0, 0, $windowWidth, $windowHeight, 1)
			Until(WinGetPos($hwnd)[2]==$windowWidth And WinGetPos($hwnd)[3]==$windowHeight)
			$firstRound = False
			EndIf
		ElseIf Not IsHWnd($hwnd) And GUICtrlGetState($idButtonStart) == $GUI_ENABLE Then
			GUICtrlSetState($idButtonStart, $GUI_DISABLE)
		ElseIf GUICtrlGetState($idButtonStart) == $GUI_DISABLE Then
			GUICtrlSetState($idButtonStart, $GUI_ENABLE)
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit 0

			Case $idButtonClose
				Exit 0

			Case $idButtonStart
				If IsHWnd($hwnd) Then
					Global $lastMousePos=MouseGetPos()
					WinActivate($hwnd)
					Do
						WinMove($hwnd, "", 0, 0, $windowWidth, $windowHeight, 1)
					Until(WinGetPos($hwnd)[2]==$windowWidth And WinGetPos($hwnd)[3]==$windowHeight)
					HotKeySet("{SPACE}", "stop")
					GuiCtrlSetFont($idButtonStart, 11)
					GUICtrlSetData($idButtonStart, "Press 'Spacebar' to stop the bot")
					GUICtrlSetState($idButtonStart, $GUI_DISABLE)
					$inviteamount = GUICtrlRead($idInputPayersToInvite)
					$PlusMinusStep=1
					if($inviteamount=="∞") Then
						$PlusMinusStep=0
						$inviteamount=0
					EndIf
					Local $skippedPlayers=0

					For $i = 0 To Int($inviteamount/$reloadlist) Step $PlusMinusStep

						$bP=GetButtonPos($xButton)
						$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 10, 1, $hwnd) 	;search the x button
						If(Not @error) Then
							MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0) 				;click the it if needed
							If ($i == 0) Then
								Sleep(300)
							EndIf
						EndIf
						$bP=GetButtonPos($chatButton)
						$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 0, 1, $hwnd) 	;search the chat popout button
						If(Not @error) Then
							MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0) 				;click the it if needed
							Sleep(300)
						EndIf
						$bP=GetButtonPos($buildersButton)
						Do
							$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 0, 1, $hwnd)		;search the "Builders" button
						Until(Not @error)
						$bP=GetButtonPos($levelButton)
						MouseClick("", $bP[0], $bP[1], 1, 0)											;click the level button
						$bP=GetButtonPos($clanButton)
						Do
							$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 0, 1, $hwnd)	;search the "clan" button
						Until(Not @error)
						MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0)						;click it
						Local $scantime = TimerInit()
						$bP=GetButtonPos($findNewMembersButton)
						Do
							if (TimerDiff($scantime)/1000) > 1 Then
								$i-=1
								$skippedPlayers=-1
								ExitLoop(2)
							EndIf
							$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 5, 1, $hwnd)	;search the "find new members" button
						Until(Not @error)
						MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0)						;click it
						;Do
						;	$pixelcoord=PixelSearch(447, 332, 447, 332, 0x425C80, 2, 1, $hwnd)	;search the "clan wars" button
						;Until(Not @error)
						;MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0)						;click it
						;sleep(5)
						;MouseClick("", 1428, 422, 1, 0)												;click the "search" button
						Local $repititions=$reloadlist											;calculate repitions for next for loop
						If $skippedPlayers>0 Then
							$repititions=$skippedPlayers
							$skippedPlayers=0

						ElseIf $skippedPlayers==-1 Then
							$repititions=0
							$skippedPlayers=0

						ElseIf $i == Int($inviteamount/$reloadlist) And $inviteamount <> "∞" Then
							$repititions=Mod($inviteamount, $reloadlist)

						EndIf


						For $j = 0 To $repititions-1 Step +1
							Local $scantime = TimerInit()
							$bP=GetButtonPos($playerButton)
							Do
								if (TimerDiff($scantime)) > 2000 Then
									$i-=1
									$skippedPlayers=$repititions-$j
									ExitLoop(2)
								EndIf
								$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[2], $bP[3], $bP[4], 20, 1, $hwnd)						;search a player
							Until(Not @error)
							MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0)				;Click at the player
							Local $scantime = TimerInit()
							$bP=GetButtonPos($inviteButton)
							Do
								if (TimerDiff($scantime)) > 2500 Then
									$i-=1
									$skippedPlayers=$repititions-$j
									ExitLoop(2)
								EndIf
								$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 0, 1, $hwnd)	;search the "invite" button
							Until(Not @error)
							MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0)						;click it

							$counterLine1=FileReadLine($filepath, 1)
							$config = FileOpen($filepath, 2)
							$counterLine1+=1
							FileWrite($config, $counterLine1&@CRLF&$profileNameLine2&@CRLF&$dragrangeLine3)							;add one player to the counter
							FileClose($config)
							GUICtrlSetData($idVarInvitedPlayersAllTime, $counterLine1)
							GUICtrlSetData($idVarInvitedPlayersSession, $counterLine1-$firstLine1)
							if $inviteamount<>"∞" Then
								GUICtrlSetData($idInputPayersToInvite, (GUICtrlRead($idInputPayersToInvite)-1))
							EndIf																				;player added
							$bP=GetButtonPos($backButton)
							MouseClick("", $bP[0], $bP[1], 1, 0)												;click the "back" button
							Local $scantime = TimerInit()
							$bP=GetButtonPos($playerButton)
							Do
								if (TimerDiff($scantime)) > 2000 Then
									$i-=1
									$skippedPlayers=$repititions-$j
									ExitLoop(2)
								EndIf
								$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[2], $bP[3], $bP[4], 20, 1, $hwnd) 	;wait the player trophy button to load again...
							Until(Not @error)
							if Mod($j, 4)==0 Then
								$newdragrange=$dragrangeLine3-1
							Else
								$newdragrange=$dragrangeLine3
							EndIf
							MouseClickDrag("", $pixelcoord[0], $dragstart, $pixelcoord[0], $dragstart-$newdragrange, 0)				;drag the mouse to the next player
							Sleep(1)
						Next

					Next
					$bP=GetButtonPos($xButton)
					$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 10, 1, $hwnd) 	;search the x button
					If(Not @error) Then
						MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0) 				;click the it if needed
					EndIf
					stop()
				Else
					GUICtrlSetState($idButtonStart, $GUI_DISABLE)
				EndIf

			Case $idButtonResetAllTime
				$config = FileOpen($filepath, 2)
				FileWrite($config, 0&@CRLF&$profileNameLine2&@CRLF&$dragrangeLine3)											;reset the counter
				FileClose($config)
				$counterLine1=0
				$firstLine1=0
				GUICtrlSetData($idVarInvitedPlayersAllTime, $counterLine1)
				GUICtrlSetData($idVarInvitedPlayersSession, $counterLine1-$firstLine1)

			Case $idButtonResetSession
				$firstLine1=$counterLine1
				GUICtrlSetData($idVarInvitedPlayersSession, $counterLine1-$firstLine1)

			Case $idButtonPlus
				if GUICtrlRead($idInputPayersToInvite)=="∞" Then
					GUICtrlSetData($idInputPayersToInvite, GUICtrlRead($idInputPlusMinusStep))
				Else
					GUICtrlSetData($idInputPayersToInvite, GUICtrlRead($idInputPayersToInvite)+GUICtrlRead($idInputPlusMinusStep))
				EndIf

			Case $idButtonMinus
				If (GuiCtrlRead($idInputPayersToInvite)-GUICtrlRead($idInputPlusMinusStep))<=0 Then
					GUICtrlSetData($idInputPayersToInvite, "∞")
				ElseIf GUICtrlRead($idInputPayersToInvite)<>"∞" Then
					GUICtrlSetData($idInputPayersToInvite, GUICtrlRead($idInputPayersToInvite)-GUICtrlRead($idInputPlusMinusStep))
				EndIf

			Case $idInputPayersToInvite
				If ((GUICtrlRead($idInputPayersToInvite)=0) Or (StringLen(GUICtrlRead($idInputPayersToInvite))>1 And StringInStr(GUICtrlRead($idInputPayersToInvite), "∞")<>0)) Then
					GUICtrlSetData($idInputPayersToInvite, "∞")
				EndIf

			Case $cEnterPressed
				If _WinAPI_GetFocus() = $hInputProfileName Then
					$config = FileOpen($filepath, 2)
					FileWrite($config, $counterLine1&@CRLF&GUICtrlRead($idInputProfileName)&@CRLF&$dragrangeLine3)											;reset the counter
					FileClose($config)
					$profileNameLine2=FileReadLine($filepath, 2)
					$hwnd = $profileNameLine2 ; The Name Of The Game
					$hwnd = WinGetHandle (WinGetTitle ($hwnd)) ; Get The Handle
					main()
				EndIf

			Case $idInputDragRange
				$config = FileOpen($filepath, 2)
				FileWrite($config, $counterLine1&@CRLF&$profileNameLine2&@CRLF&GUICtrlRead($idInputDragRange))
				FileClose($config)
				$dragrangeLine3=FileReadLine($filepath, 3)

			Case $idButtonResetButtonPos
				GUICtrlSetState($idButtonResetButtonPos, $GUI_DISABLE)
				GetButtonPos(-1, 2)
				GUICtrlSetState($idButtonResetButtonPos, $GUI_ENABLE)
		EndSwitch
	WEnd


		GUIDelete($hGUI)
EndFunc

Func GetButtonPos($actionID=-1, $mode=1) ;Mode1 = Read Button Pos; Mode2 = Write Button Pos
	If ($mode==1) Then
		$posConfig = FileOpen($posConfigFilepath, 0)
		Switch $actionID
			case $xButton
				$bP=StringSplit(FileReadLine($posConfig, $xButton), ",", 2)
				Return $bP
			case $chatButton
				$bP=StringSplit(FileReadLine($posConfig, $chatButton), ",", 2)
				Return $bP
			case $buildersButton
				$bP=StringSplit(FileReadLine($posConfig, $buildersButton), ",", 2)
				Return $bP
			case $levelButton
				$bP=StringSplit(FileReadLine($posConfig, $levelButton), ",", 2)
				Return $bP
			case $clanButton
				$bP=StringSplit(FileReadLine($posConfig, $clanButton), ",", 2)
				Return $bP
			case $findNewMembersButton
				$bP=StringSplit(FileReadLine($posConfig, $findNewMembersButton), ",", 2)
				Return $bP
			case $playerButton
				$bP=StringSplit(FileReadLine($posConfig, $playerButton), ",", 2)
				Return $bP
			case $inviteButton
				$bP=StringSplit(FileReadLine($posConfig, $inviteButton), ",", 2)
				Return $bP
			case $backButton
				$bP=StringSplit(FileReadLine($posConfig, $backButton), ",", 2)
				Return $bP
		EndSwitch
		FileClose($posConfig)
	ElseIf ($mode==2) Then
		If Not FileExists($posConfigFilepath) Then
			$posConfig = FileOpen($posConfigFilepath, 2)
			FileClose($posConfig)
		EndIf


		$hmb = MsgBox(0, "First Step", "Open the chat popup and from there the clan button on the top. Then press 'OK'", Default, $hGUI)
		$hmb = MsgBox(0, "X Button", "Hover over the red area of the X Button and press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 2)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, $x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Chat Button", "Hover over the orange area of the Close Chat Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Builders Button", "Hover over the Nose of the Builders Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Level Button", "Hover over the Center of the Level Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Clan Button", "Hover over the dark area of the Clan Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Find New Members Button", "Hover over the dark blue area of the Find New Members Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MouseClick("primary")


		$hmb = MsgBox(0, "Player Button", "First Hover over the Center of the Builders Base Trophy Button. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		Local $color=PixelGetColor(MouseGetPos(0), MouseGetPos(1), $hwnd)
		$hmb = MsgBox(0, "Player Button", "Hover over the Left Top Corner of the Area where the Trophie can be (if dragged up or down). Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1)
		$hmb = MsgBox(0, "Player Button", "Hover over the Right Bottom Corner. Then press Spacebar", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		Local $x2=MouseGetPos(0), $y2=MouseGetPos(1)
		$posConfig = FileOpen($posConfigFilepath, 1)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$x2&","&$y2&","&$color)
		FileClose($posConfig)


		MouseClick("primary")
		$hmb = MsgBox(0, "Invite Button", "Hover over the green area of the Invite Button", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)


		$hmb = MsgBox(0, "Back Button", "Hover over the green area of the Back Button", Default, $hGUI)
		WinActivate($hwnd)
		Do
			Sleep(1)
		Until _IsPressed(20)
		$posConfig = FileOpen($posConfigFilepath, 1)
		Local $x1=MouseGetPos(0), $y1=MouseGetPos(1), $color=PixelGetColor($x1, $y1, $hwnd)
		FileWrite($posConfig, @CRLF&$x1&","&$y1&","&$color)
		FileClose($posConfig)
		MsgBox(0, "Setup Completed", " ", Default, $hGUI)


	EndIf
EndFunc



Func stop()
	HotKeySet("{SPACE}")
	$bP=GetButtonPos($xButton)
	$pixelcoord=PixelSearch($bP[0], $bP[1], $bP[0], $bP[1], $bP[2], 10, 1, $hwnd) 	;search the x button
	If(Not @error) Then
		MouseClick("", $pixelcoord[0], $pixelcoord[1], 1, 0) 				;click the it if needed
	EndIf
	MouseMove($lastMousePos[0], $lastMousePos[1], 0)
	main()
EndFunc
