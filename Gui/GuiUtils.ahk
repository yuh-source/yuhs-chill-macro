#Requires AutoHotkey v2.0

WM_MOVE(wParam, lParam, msg, hwnd) {
    if !WinExist("ahk_exe RobloxPlayerBeta.exe") || GuiFromHwnd(hwnd).Title != "Yuh's Chill AV Macro"
        return
    SetWinDelay(-1)
    WinMove(lParam & 0xFFFF - 9, (lParam >> 16) + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    if unlocked {
        PostMessage(0xA1, 2)
    }
}

OnMessage(0x0003, WM_MOVE) ; make roblox window follow

OnMessage(0x201, WM_LBUTTONDOWN) ; allow window dragging by clicking anywhere

ExitGui(reloadScript := false) {
    KillTinyTask()
    psLinkFile.Close()
    webhookFile.Close()
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
    for i, stage in stageArrays[legendStageToggle.Value + 1]
        if currentStage = stage || currentStage ~= "Shibuya(Station|Aftermath)"
            userStage.Choose(i)
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
        ; static prio1, prio2, prio3, prio4
        InsertText(processText, "Choose Your Paragon Priority")
        cardPriority := MacroGui("+AlwaysOnTop", "Choose Your Paragon Priority")
        cardPriority.BackColor := "0x2f2f2f"

        ; ["thrice", "regen", "strong", "shielded", "exploding", "fast", "revitalise", "quake", "champions", "dodge", "drowsy", "immunity"]

        cardPriority.AddText("c0xFFFFFF x15 y15", "First Priority")
        prio1 := cardPriority.AddDDL("x15 y30 w100 Choose4", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x130 y15", "Second Priority")
        prio2 := cardPriority.AddDDL("x130 y30 w100 Choose2", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x245 y15", "Third Priority")
        prio3 := cardPriority.AddDDL("x245 y30 w100 Choose3", paragonOptions)

        cardPriority.AddText("c0xFFFFFF x360 y15", "Fourth Priority")
        prio4 := cardPriority.AddDDL("x360 y30 w100 Choose11", paragonOptions)

        confirmButton := cardPriority.AddButton("x188 y65 w100", "Confirm")
        confirmButton.OnEvent("Click", savePriority)

        ; cardPriority.AddText("c0xFFFFFF x130 y60 w225", "First Card Delay(Increase if not detecting)")
        ; global firstCardDelay := cardPriority.AddSlider("x125 y75 w225 NoTicks Range2000-20000 ToolTip", 10000)

        cardPriority.Show("w475 h100")
    }

    savePriority(*) {
        global cardOrder := [prio1.Text, prio2.Text, prio3.Text, prio4.Text]
        cardPriority.Destroy()
    }
}

CreateWebHookGUI(*) {
    InsertText(processText, "Set Your Webhook")
    webhookGUI := MacroGui("+AlwaysOnTop", "Choose Your Paragon Priority")
    webhookGUI.BackColor := "0x2f2f2f"

    webhookGUI.SetFont("s11")
    webhookGUI.AddText("x10 y10 c0xFFFFFF", "Discord Webhook URL:")
    webhookURL := webhookGUI.AddEdit("x10 y30 w280 r1", webhookFile.Read())
    saveWebhook := webhookGUI.AddButton("x10 y60", "Save Webhook")
    saveWebhook.OnEvent("Click", WriteWebhookURL)

    webhookGUI.Show("w300 h100")

    WriteWebhookURL(*) {
        if webhookURL.Text ~= "^https?:\/\/discord\.com\/api\/webhooks\/\d+\/[\w|-]+$" {
            writeWebhook := FileOpen(A_WorkingDir "\Settings\DiscordWebhook.txt", "w")
            writeWebhook.Write(webhookURL.Text)
            InsertText(processText, "Saving Webhook URL")
            webhookGUI.Destroy()
        } else {
            InsertText(processText, "Invalid Webhook Url")
        }
    }
}


WritePsLink(*) {
    if psLink.Text ~= privRegex or psLink.Text ~= altPrivRegex {
        local WritePS := FileOpen(A_WorkingDir "\Settings\PSLink.txt", "w")
        WritePS.Write(psLink.Text)
        WritePS.Close()
        InsertText(processText, "Saving Priv Server Link")
    } else {
        MsgBox("invalid prive server link")
    }
}

InsertText(ctrl, text) {
    ctrl.Value .= text "`n"
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