#Requires AutoHotkey v2.0 

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    if MacroGui.lockToggle = -1 {
        PostMessage(0xA1, 2)
    }
}

WM_MOVE(wParam, lParam, msg, hwnd) {
    if !WinExist("ahk_exe RobloxPlayerBeta.exe") || GuiFromHwnd(hwnd).Title != "Yuh's Chill AV Macro"
        return
    SetWinDelay(-1)
    WinMove(lParam & 0xFFFF - 9, (lParam >> 16) + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
} 

OnMessage(0x201, WM_LBUTTONDOWN)

OnMessage(0x0003, WM_MOVE)

updateRunInfo() {
    MacroGui.ui["displayLoops"].Text := "Macro Loops: " Macro.loopCount
    timeDiffMins := DateDiff(A_Now, Macro.startTime, "minutes") 
    MacroGui.ui["timeElapsed"].Text := "Macro Runtime: " timeDiffMins " Mins"
    timeDiffHours := DateDiff(A_Now, Macro.startTime, "hours")
    MacroGui.ui["rph"].Text := "Runs Per Hour: " (timeDiffHours > 0 ? Round(Macro.loopCount / timeDiffHours) : 0)
    MacroGui.ui["displayChals"].Text := "Challenges Done: " Macro.chalCount
}

class MacroGui {
    static stageArrays := [["PlanetNamek", "SandVillage", "DoubleDungeon", "ShibuyaStation"], ["SandVillage", "DoubleDungeon", "ShibuyaAftermath"]]
    static actArrays := [[1, 2, 3, 4, 5, 6, "Infinite", "Paragon"], [1, 2, 3]]
    static raidArray := [1, 2, 3, 4]

    static modArray := ["thrice", "regen", "strong", "shielded", "exploding", "fast", "revitalise", "quake", "champions", "dodge", "drowsy", "immunity"]
    static modPrio := [] ; ["shielded", "regen", "strong", "drowsy"] by default

    static lockToggle := 1
    static ui := GuiMethods("-Caption +Border +AlwaysOnTop", "Yuh's Chill AV Macro")

    static Show() {
        this.ui.BackColor := "0x2f2f2f"
        this.ui.Show("x15 y15 w1250 h637")
        this.ui.OnEvent("Close", (*) => GuiMethods.Close())
    
        this.ui.AddPic("vbgPic x800 y36 w450 h600 0x4000000", A_ScriptDir "\lib\resources\UI\him.jpg")
        WinSetTransparent("30", this.ui["bgPic"])
    
        this.ui.AddPic("vcloseButton x1220 y3", A_ScriptDir "\lib\resources\UI\xbutton.png").OnEvent("Click", (*) => GuiMethods.Close())
        WinSetTransparent("255", this.ui["closeButton"])
    
        this.ui.AddPic("vminimiseButton x1177 y3", A_ScriptDir "\lib\resources\UI\mbutton.png").OnEvent("Click", (*) => WinMinimize("Yuh's Chill AV Macro"))
        WinSetTransparent("255", this.ui["minimiseButton"])

        this.ui.AddPic("vlockWindow x1135 y3 w27 h27", A_ScriptDir "\lib\resources\UI\lock2.png").OnEvent("Click", (*) => this.Lock(this.ui["lockWindow"]))
        WinSetTransparent("255", this.ui["lockWindow"])

        this.ui.SetFont("s20")
        this.ui.AddText("c0xFFFFFF x10 y2", "Yuh's Chill AV Macro")
        this.ui.SetFont("s8")

        this.ui.AddProgress("c0x2f2f2f x0 y0 h35 w1250", 100) ; title bar
        this.ui.AddProgress("c0x7e4141 x0 y35 h602 w800", 100) ; trans area behind roblox
        WinSetTransColor("0x7e4141 255", this.ui)

        this.ui.AddTitleGroupBox("0xf1d693", 815, 45, "Keybinds") ; keybinds box 
        this.ui.AddText("c0xFFFFFF x825 y70", "Full Macro: F1          Macro Setup F3         Stop Macro: F4`nCard Picker: F2")

        this.ui.AddTitleGroupBox("0xa537fd", 815, 115, "Special Options") ; Special options box 
        this.ui.AddCheckbox("vretryToggle c0xFFFFFF x825 y135 Checked", "Auto Restart Full Macro On Error")
        this.ui.AddCheckbox("vcraftToggle c0xFFFFFF x1025 y135", "Auto Craft Green Crystals")
        this.ui.AddCheckbox("vchallToggle c0xFFFFFF x825 y153", "Auto Complete Challenges")

        this.ui.AddTitleGroupBox("0x3DC2FF", 815, 185, "Level Options", , 55) ; Level Options Box 
        this.ui.AddDDL("vuserStage x825 y207 w120 r4", this.stageArrays[1])
        this.ui.AddDDL("vuserAct x955 y207 w75 r8", this.actArrays[1]).OnEvent("Change", (*) => this.Paragon())
        this.ui.AddCheckbox("vlegToggle c0xFFFFFF x1040 y211","Legend Stage").OnEvent("Click", (*) => this.AltStageCtrl())

        this.ui.AddTitleGroupBox("0xff4c30", 815, 250, "Raid Options", 205, 55) ; Raid Box
        this.ui.AddCheckbox("vraidToggle c0xFFFFFF x825 y275", "Select For Raid").OnEvent("Click", (*) => MsgBox("Raid is heavily broken rn, dont use"))
        this.ui.AddDDL("x930 y270 w50 r4", this.raidArray)

        this.ui.AddTitleGroupBox("0xff7b00", 1035, 250, "Boss Rush", 200, 55)
        this.ui.AddCheckbox("vbossToggle c0xFFFFFF x1045 y275", "Select For Boss Rush")

        this.ui.AddTitleGroupBox("0x3fc380", 815, 315, "Private Server", , 90) ; Priv Server Box
        this.ui.AddCheckbox("vprivToggle c0xFFFFFF x825 y345 Checked","Use Private Server")
        this.ui.AddButton("vsaveLink x1092 y340", "Save Private Server Link").OnEvent("Click", (*) => this.savePSLink())
        this.ui.AddEdit("vpsLink x825 y370 w400 r1", FileMethods.Read(A_ScriptDir "\Settings\PSLink.txt"))

        this.ui.AddTitleGroupBox("0xc300ff", 815, 415, "Process Log", 225, 150)
        this.ui.SetFont("s11")
        this.ui.AddText("vprocess c0xFFFFFF x830 y438 w180 r7", "")

        this.ui.AddTitleGroupBox("0xff00aa", 1050, 415, "Macro Info", 185, 150)
        this.ui.SetFont("s11")
        this.ui.AddText("vdisplayLoops c0xFFFFFF x1065 y438 w155", "Macro Loops: " Macro.loopCount)
        this.ui.AddText("vtimeElapsed c0xFFFFFF x1065 y458 w155", "Macro Runtime: " 0 " Mins")
        this.ui.AddText("vrph c0xFFFFFF x1065 y478 w155", "Runs Per Hour: " 0)
        this.ui.AddText("vdisplayChals c0xFFFFFF x1065 y498 w155", "Challenges Done: " Macro.chalCount)
        SetTimer(updateRunInfo, 15000)

        this.ui.AddButton("vstartButton x815 y585 w100 h30", "Start Macro") ; .OnEvent("Click", (*) => FullMacro())
        this.ui.AddButton("vstopButton x935 y585 w100 h30", "Stop Macro").OnEvent("Click", (*) => GuiMethods.Close(true))

        this.ui.AddButton("vwebhbutton x1055 y585 w100 h30", "Webhook").OnEvent("Click", this.WebHook)

        this.ui.AddPic("vdImage x1180 y570", A_ScriptDir "\lib\resources\UI\discord.png").OnEvent("Click", (*) => Run("https://discord.gg/aZZVgMrXCS"))
        WinSetTransparent("255", this.ui["dImage"])

    }

    static addProcess(text) {
        this.ui["process"].Value .= text "`n"
    }

    static Lock(ctrl) {
        this.lockToggle *= -1

        if this.lockToggle = -1 {
            ctrl.Value := A_ScriptDir "\lib\resources\UI\lock1.png"
        } else {
            ctrl.Value := A_ScriptDir "\lib\resources\UI\lock2.png"
        }
    }

    static AltStageCtrl() {
        toggle := this.ui["legToggle"].Value, cStage := this.ui["userStage"].Text
        GuiMethods.ChangeDDL(this.ui["userStage"], this.stageArrays, this.ui["legToggle"].Value)

        for i, stage in this.stageArrays[toggle + 1]
            if cStage = stage || cStage ~= "Shibuya(Station|Aftermath)"
                this.ui["userStage"].Choose(i)

        GuiMethods.ChangeDDL(this.ui["userAct"], this.actArrays, this.ui["legToggle"].Value)
    }

    static Paragon(*) {
        if this.ui["userAct"].Value = 8 {
            cardPrio := GuiMethods("+AlwaysOnTop", "Choose Your Paragon Priority")
            cardPrio.BackColor := "0x2f2f2f"
            cardPrio.Show("w475 h100")
    
            ; ["thrice", "regen", "strong", "shielded", "exploding", "fast", "revitalise", "quake", "champions", "dodge", "drowsy", "immunity"]
            cardPrio.AddText("c0xFFFFFF x15 y15", "First Priority")
            cardPrio.AddDDL("vprio1 x15 y30 w100 Choose4", this.modArray)
    
            cardPrio.AddText("c0xFFFFFF x130 y15", "Second Priority")
            cardPrio.AddDDL("vprio2 x130 y30 w100 Choose2", this.modArray)
    
            cardPrio.AddText("c0xFFFFFF x245 y15", "Third Priority")
            cardPrio.AddDDL("vprio3 x245 y30 w100 Choose3", this.modArray)
    
            cardPrio.AddText("c0xFFFFFF x360 y15", "Fourth Priority")
            cardPrio.AddDDL("vprio4 x360 y30 w100 Choose11", this.modArray)

            cardPrio.AddButton("vcbutton x188 y65 w100", "Confirm").OnEvent("Click", (*) => SavePriority())
        }
    
        savePriority(*) {
            this.modPrio := [cardPrio["prio1"].Text, cardPrio["prio2"].Text, cardPrio["prio3"].Text, cardPrio["prio4"].Text]
            cardPrio.Destroy()
        }
    }

    static savePSLink() {
        reg1 := "https:\/\/www\.roblox\.com(\/[a-z]{2})?\/games\/\d+\/[a-zA-Z0-9-]+(\?privateServerLinkCode=\d+)?"
        reg2 := "https://www\.roblox\.com/share\?code=fa([0-9]+([A-Za-z]+[0-9]+)+)[A-Za-z]+&type=Server"
        if !RegExMatch(this.ui["psLink"].Text, reg1) && !RegExMatch(this.ui["psLink"].Text, reg2) {
            MsgBox("Invalid Private Server Link")
            return
        }
        FileMethods.Write(A_ScriptDir "\Settings\PSLink.txt", this.ui["psLink"].Text)
        
    }

    static WebHook(*) {
        webhGUI := GuiMethods("+AlwaysOnTop", "Choose Your Paragon Priority")
        webhGUI.BackColor := "0x2f2f2f"
        webhGUI.Show("w300 h100")

        webhGUI.SetFont("s11")
        webhGUI.AddText("x10 y10 c0xFFFFFF", "Discord Webhook URL:")
        webhGUI.AddEdit("vwebhURL x10 y30 w280 r1", FileMethods.Read(A_ScriptDir "\Settings\DiscordWebhook.txt"))
        webhGUI.AddButton("vsavewebhButton x10 y60", "Save Webhook").OnEvent("Click", saveWebHURL)

        saveWebHURL(*) {
            if webhGui["webhURL"].Text ~= "^https?:\/\/discord\.com\/api\/webhooks\/\d+\/[\w|-]+$" {
                FileMethods.Write(A_ScriptDir "\Settings\DiscordWebhook.txt", webhGui["webhURL"].Text)
                webhGUI.Destroy()
                return
            }
            MsgBox("Invalid Webhook Url")
        }
    }
}