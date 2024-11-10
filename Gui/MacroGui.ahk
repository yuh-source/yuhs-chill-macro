#Requires AutoHotkey v2.0

global stageArrays := [["PlanetNamek", "SandVillage", "DoubleDungeon", "ShibuyaStation"], ["SandVillage", "DoubleDungeon", "ShibuyaAftermath"]]
global actArrays := [[1, 2, 3, 4, 5, 6, "Infinite", "Paragon"], [1, 2, 3]]
global raidActArray := [1, 2, 3, 4]
global paragonOptions := ["thrice", "regen", "strong", "shielded", "exploding", "fast", "revitalise", "quake", "champions", "dodge", "drowsy", "immunity"]

ui := MacroGui("-Caption +Border +AlwaysOnTop", "Yuh's Chill AV Macro")

ui.Show("x15 y15 w1250 h637")
ui.BackColor := "0x2f2f2f"

bgPic := ui.AddPic("x800 y36 w450 h600 0x4000000", A_ScriptDir "\Images\UI\him.jpg") ; bg image
WinSetTransparent("30",  bgPic)

closeButton := ui.AddPic("x1220 y3", A_ScriptDir "\Images\UI\Exit Button.png") ; close button image
WinSetTransparent("255", closeButton)
closeButton.OnEvent("Click", (*) => ExitGui())

minimiseButton := ui.AddPic("x1177 y3", A_ScriptDir "\Images\UI\Minimise Button.png")
WinSetTransparent("255", minimiseButton)
minimiseButton.OnEvent("Click", (*) => WinMinimize("Yuh's Chill AV Macro"))

global lockWindow := ui.AddPic("x1135 y3 w27 h27", A_ScriptDir "\Images\UI\closed lock.png")
WinSetTransparent("255", lockWindow)
lockWindow.OnEvent("Click", changeLock)

closeButton.OnEvent("Click", (*) => ExitGui())
ui.OnEvent("Close", (*) => ExitGui())

ui.SetFont("s20")
ui.AddText("c0xFFFFFF x10 y2", "Yuh's Chill AV Macro") ; title text
ui.SetFont("s8")

ui.AddProgress("c0x2f2f2f x0 y0 h35 w1250", 100) ; title bar
ui.AddProgress("c0x7e4141 x0 y35 h602 w800", 100) ; box behind roblox
WinSetTransColor("0x7e4141 255", ui)

ui.CreateTitleGroupBox("0xf1d693", 815, 45, "Keybinds") ; keybinds box 
ui.AddText("c0xFFFFFF x825 y70", "Full Macro: F1          Macro Setup F3         Stop Macro: F4`nCard Picker: F2")

ui.CreateTitleGroupBox("0xa537fd", 815, 115, "Special Options") ; Special options box 
global autoRetry := ui.AddCheckbox("c0xFFFFFF x825 y135 Checked", "Auto Restart Full Macro On Error")
global userCraftCrystals := ui.AddCheckbox("c0xFFFFFF x1025 y135", "Auto Craft Green Crystals")
global autoChallenges := ui.AddCheckbox("c0xFFFFFF x825 y153", "Auto Complete Challenges")

ui.CreateTitleGroupBox("0x3DC2FF", 815, 185, "Level Options", , 55) ; Level Options Box 
global userStage := ui.AddDDL("x825 y207 w120 r4", stageArrays[1])
global userAct := ui.AddDDL("x955 y207 w75 r8", actArrays[1])
global legendStageToggle := ui.AddCheckbox("c0xFFFFFF x1040 y211","Legend Stage")

userAct.OnEvent("Change", ChooseParagonPriority)
legendStageToggle.OnEvent("Click", (*) => AltStageActArrays(userStage.Text))

ui.CreateTitleGroupBox("0xff4c30", 815, 250, "Raid Options", 205, 55) ; Raid Box
global raidToggle := ui.AddCheckbox("c0xFFFFFF x825 y275", "Select For Raid")
global userRaidAct := ui.AddDDL("x930 y270 w50 r4", raidActArray)
raidToggle.OnEvent("Click", (*) => MsgBox("Raid is heavily broken rn, dont use"))

ui.CreateTitleGroupBox("0xff7b00", 1035, 250, "Boss Rush", 200, 55)
global bossToggle := ui.AddCheckbox("c0xFFFFFF x1045 y275", "Select For Boss Rush")

ui.CreateTitleGroupBox("0x3fc380", 815, 315, "Private Server", , 90) ; Priv Server Box
global usePriv := ui.AddCheckbox("c0xFFFFFF x825 y345 Checked","Use Private Server")
global savePrivLink := ui.AddButton("x1092 y340", "Save Private Server Link")
global psLink := ui.AddEdit("x825 y370 w400 r1", psLinkFile.read()) ; we bringing back regex with this one :speaking_head: :fire: :bangbang:

savePrivLink.OnEvent("Click", WritePsLink)

ui.CreateTitleGroupBox("0xc300ff", 815, 415, "Process Log", 225, 150)
ui.SetFont("s11")
global processText := ui.AddText("c0xFFFFFF x830 y438 w180 r7", "")

ui.CreateTitleGroupBox("0xff00aa", 1050, 415, "Macro Info", 185, 150)
ui.SetFont("s11")
global displayLoops := ui.AddText("c0xFFFFFF x1065 y438 w155", "Macro Loops: 0")
global timeElapsed := ui.AddText("c0xFFFFFF x1065 y458 w155", "Macro Runtime: 0 Mins")
global runsPerHour := ui.AddText("c0xFFFFFF x1065 y478 w155", "Runs Per Hour: 0")
global challengesCompleted := ui.AddText("c0xFFFFFF x1065 y498 w155", "Challenges Done: 0")
SetTimer(updateRunInfo, 15000)

startButton := ui.AddButton("x815 y585 w100 h30", "Start Macro")
stopButton := ui.AddButton("x935 y585 w100 h30", "Stop Macro")
startButton.OnEvent("Click", (*) => FullMacro())
stopButton.OnEvent("Click", (*) => ExitGui(true))

webhookButton := ui.AddButton("x1055 y585 w100 h30", "Webhook")
webhookButton.OnEvent("Click", CreateWebHookGUI)

discordImage := ui.AddPic("x1180 y570", A_ScriptDir "\Images\UI\Discord.png")
WinSetTransparent("255", discordImage)

discordImage.OnEvent("Click", JoinDiscord)