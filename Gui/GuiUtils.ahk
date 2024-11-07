#Requires AutoHotkey v2.0

WM_MOVE(wParam, lParam, msg, hwnd) {
    SetWinDelay(-1)
    local X := lParam & 0xFFFF
    local Y := lParam >> 16
    GuiObject := GuiFromHwnd(hwnd)

    try {
        title := GuiObject.Title
    } catch {
        title := ""
    }

    if WinExist("ahk_exe RobloxPlayerBeta.exe") and title = "Yuh's Chill AV Macro" {
        WinMove(X-9, Y+5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
    }
    ; WinRedraw(thisGui)
    ; ToolTip("moved " GuiObject.Title " to X: " X " Y: " Y)
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    if unlocked {
        PostMessage(0xA1, 2)
    }
}

; WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
;     static X, Y, GuiControl, prevControl
;     MouseGetPos(,,, &guiControl)

;     text := ""
;     prevControl := ""
;     if guiControl = "Button3" {
;         text := "testing"
;     }
;     else if guiControl = "Button2" {
;         text := "uhhh"
;     }
;     else if guiControl = "Button4" {
;         text := "hmmmmm"
;     }

;     if text != "" and GuiControl != prevControl{
;         ControlGetPos(&X, &Y,,, GuiControl)
;         SetTimer(CreateToolTip, 500)
;         prevControl := GuiControl
;     }

;     CreateToolTip() {
;         SetTimer , 0
;         ToolTip(text, X, Y)
;         SetTimer(RemoveToolTip, 2000)
;         isToolTip := true ; :cryingcausemycodewontwork:
;     }
;     RemoveToolTip() {
;         SetTimer , 0
;         ToolTip()
;     }
; }

OnMessage(0x0003, WM_MOVE) ; make roblox window follow

OnMessage(0x201, WM_LBUTTONDOWN) ; allow window dragging by clicking anywhere

; OnMessage(0x200, WM_MOUSEMOVE) ; trying to add tooltips when hovering checkboxes (NOT WORKING)


ExitGui(reloadScript := false) {
    KillTinyTask()
    if !reloadScript {
        if WinExist("ahk_exe RobloxPlayerBeta.exe") {
            WinMove(7, 21, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
        }
        ExitApp()
    } else {
        reload()
        Sleep(1000)
    }
}

KillTinyTask() {
    try {
        if ProcessClose(ttaskPID) != 0 {
            InsertText(processText, "Blew TinyTask To Smithereens")
            Sleep(1000)
        }
    }
    return
}

changeLock(*) {
    global lockWindow, unlocked
    static lockToggle := 1

    lockToggle *= -1

    if lockToggle = -1 {
        lockWindow.Value := A_ScriptDir "\Images\UI\open lock.png"
        unlocked := true
    } else {
        lockWindow.Value := A_ScriptDir "\Images\UI\closed lock.png"
        unlocked := false
    }
}

; CreateUnitConfig(uiObject, index, x, y) {
;     uiobject.CreateTitleGroupBox("0xFFFFFF", x, y, Format("Slot {}", index), 135, 125)
;     uiObject.AddDDL(Format("x{} y{} w75", x+10, y+20), ["Vegeta", "SJW", "Cha-in", "Wagon", "Sakura", "Takaroda"])
;     uiObject.AddDDL(Format("x{} y{} w90", x+10, y+50), ["Main DPS", "Sub DPS", "Statue Breaker"])
; }

AltStageActArrays(currentStage) {
    ChangeDDL(userStage, stageArrays, legendStageToggle.Value)
    for index, stage in stageArrays[legendStageToggle.Value + 1] {
        if currentStage = stage or currentStage = "ShibuyaStation" or currentStage = "ShibuyaAftermath" {
            userStage.Choose(index)
        }
    }
    ChangeDDL(userAct, actArrays, legendStageToggle.Value)
}

ChangeDDL(GuiControl, uiArrays, toggleVar := 0) {
    local currentIndex := GuiControl.Value

    GuiControl.Delete()
    GuiControl.Add(uiArrays[toggleVar + 1])

    if currentIndex > uiArrays[toggleVar + 1].Length {
        GuiControl.Choose(1)
        return false
    } else {
        GuiControl.Choose(currentIndex)
        return true
    }
}

ChooseParagonPriority(*) {
    if userAct.Value = 8 {
        static prio1, prio2, prio3
        InsertText(processText, "Choose Your Paragon Priority")
        cardPriority := MacroGui("+AlwaysOnTop", "Choose Your Paragon Priority")
        cardPriority.BackColor := "0x2f2f2f"

        ; ["thrice", "regen", "strong", "shielded", "exploding", "fast", "revitalise", "quake", "champions", "dodge", "drowsy", "immunity"]

        cardPriority.AddText("c0xFFFFFF x15 y15", "First Priority")
        prio1 := cardPriority.AddDDL("x15 y30 w100 Choose2", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x130 y15", "Second Priority")
        prio2 := cardPriority.AddDDL("x130 y30 w100 Choose1", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x245 y15", "Third Priority")
        prio3 := cardPriority.AddDDL("x245 y30 w100 Choose9", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x360 y15", "Fourth Priority")
        prio4 := cardPriority.AddDDL("x360 y30 w100 Choose4", paragonOptions)

        confirmButton := cardPriority.AddButton("x188 y65 w100", "Confirm")
        confirmButton.OnEvent("Click", savePriority)

        ; cardPriority.AddText("c0xFFFFFF x130 y60 w225", "First Card Delay(Increase if not detecting)")
        ; global firstCardDelay := cardPriority.AddSlider("x125 y75 w225 NoTicks Range2000-20000 ToolTip", 10000)

        cardPriority.Show("w475 h100")
    }

    savePriority(*) {
        global cardOrder := [prio1.Text, prio2.Text, prio3.Text]
        cardPriority.Destroy()
    }
}

WritePsLink(*) {
    if psLink.Text ~= privRegex or psLink.Text ~= altPrivRegex {
        local WritePS := FileOpen(A_WorkingDir "\Settings\PSLink.txt", "w")
        WritePS.Write(psLink.Text)
        InsertText(processText, "Saving Priv Server Link")
    } else {
        MsgBox("invalid prive server link")
    }
}

InsertText(GuiControl, text) {
    processText.Text := text "`n" processText.Text 
}

JoinDiscord(*) {
    InsertText(processText, "Welcome To The Discord!")
    Run("https://discord.gg/aZZVgMrXCS")
}

updateRunInfo(*) {
    timeMins := DateDiff(A_Now, startTime, 'M')

    if timeMins > 0 {
        timeElapsed.Text := "Macro Runtime: " timeMins " Mins"
        runsPerHour.Text := "Runs Per Hour: " Round((displayLoopCount / timeMins) * 60, 1)
    }
}

StrInlist(var, arr) {
    for key, value in arr
		if (value == var)
			return true
    return false
}