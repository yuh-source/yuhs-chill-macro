#Requires AutoHotkey v2.0 

class Macro {
    static loopCount := 0
    static chalCount := 0
    static startTime := A_Now

    static Join() {
        if LevelUI.Lobby() {
            MacroGui.addProcess("Attatching to Roblox")
            Roblox.Focus()
            WinGetPos(&X, &Y,,, MacroGui.ui)
            WinMove(X - 8, Y + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
        } else {
            Roblox.Join()
        }
    }

    static initLoop() {
        if !Setup.Run(true) {
            return false
        }
        while this.Loop() {
            this.loopCount++
        }
        return false
    }

    static Loop() {
        MacroGui.addProcess(MacroGui.ui["userStage"].Text MacroGui.ui["userAct"].Value)
        stagePath := MacroGui.ui["raidToggle"].value ? "\TinyTask\Raid" MacroGui.ui["userRaidAct"].Value ".exe" : "\TinyTask\" MacroGui.ui["userStage"].Text MacroGui.ui["userAct"].Value ".exe"
        standardPath := MacroGui.ui["raidToggle"].value ? "\TinyTask\RaidStandard.exe" : "\TinyTask\" MacroGui.ui["userStage"].Text "Standard.exe"
        useTinyTask := TTaskMethods.Ctrl(A_ScriptDir (FileExist(A_ScriptDir stagePath) ? A_ScriptDir stagePath : A_ScriptDir standardPath))

        if useTinyTask {
            MacroGui.addProcess("Finished " MacroGui.ui["userStage"].text MacroGui.ui["userAct"].Value ".exe")
        } else {
            try {
                stage := MacroGui.ui["raidToggle"].Value ? "Raid" : MacroGui.ui["userStage"].Text
                act := MacroGui.ui["raidToggle"].Value ? MacroGui.ui["userRaidAct"].Value : MacroGui.ui["userAct"].Value
                if RunActFunc(stage, act) {
                    MacroGui.addProcess(stage act " Done")
                } else {
                    MacroGui.addProcess(stage " Standard Done")
                }
            } catch {
                MacroGui.addProcess("Unable To Find Stage/Act")
            }
        }

        RunActFunc(stage, act) {
            try {
                %stage "Act" act%()
                return true
            } catch {
                %stage "Standard"%()
                return false
            }
        }

        if MacroGui.ui["userAct"].Value != 7 {
            if !LevelUI.Rewards() {
                return false
            }
        }

        if !Utils.ImageSearchLoop(Images.level.returnToLobby, 555, 440, 690, 470, 2000, 120) {
            MacroGui.addProcess("Cant Return To Lobby")
            return false
        }
        MacroGui.addProcess("Macro Ended")

        if FileMethods.Read("\Settings\DiscordWebhook.txt") != "" {
            Capture.ToWebHook()
        }
        
        if (DateDiff(Lobby.prevChallengeTime, A_Now, 'M') <= -30 && MacroGui.ui["chalToggle"].Value) 
            || (MacroGui.ui["craftToggle"].Value && this.loopCount >= 25) 
            || this.loopCount >= 25
            || Lobby.inChallenge {
            LevelUI.Lobby()
            if !Utils.ImageSearchLoop(Images.lobby.play, 60, 250, 125, 325, 1000, 60)
                MacroGui.addProcess("Cant Find Start")
            return false
        }
        
        if MacroGui.ui["userAct"].Value = 8 {
            LevelUI.Start(true, false), Paragon.Pick(false)
            return LevelUI.Start()
        }
        return LevelUI.Start(true)
    }
}

class Paragon {
    static Pick(firstCard := true) {
        if firstCard {
            if !Utils.ImageSearchLoop(Images.level.stageInfo, 710, 395, 780, 415, 1000, 60) {
                MacroGui.addProcess("Cant Detect Stage Info")
            }
            Sleep(3000)
        }
    
        while true {
            cardFound := false
            Sleep(1500)
            for modifier in MacroGui.modPrio {
                if Utils.ImageSearchLoop(%"Images.level.paragon[" modifier "]"%, 190, 270, 620, 305, 0, 2, &X, &Y) {
                    Utils.wClick("left", X, Y)
                    cardFound := true
                }
                
                if cardFound {
                    firstCard := false
                    Sleep(50)
                    MouseMove(410, 470)
                    continue 2
                }
            }
            break
        }
    
        if firstCard {
            MacroGui.addProcess("First Card Was Bad")
            LevelUI.MiscSettings("Lobby")
            return false
        } else {
            MacroGui.addProcess("Selected All Modifiers")
            return true
        }
    }
}

class Unit {
    __New(unitSlot, x, y, xOffset := 2, yOffset := -5) {
        this.unitSlot := unitSlot
        this.x := x
        this.y := y
        this.xOffset := xOffset
        this.yOffset := yOffset
        this.level := 0

        this.Place()
    }

    Properties() {
        MsgBox("unit slot " this.unitSlot "`n (" this.x ", " this.y ")`n current level: " this.level)
    }

    Place() {
        MacroGui.addProcess("Placing Unit " this.unitSlot " at (" this.x ", " this.y ")")
        Roblox.Focus()
        SendInput("{" this.unitSlot "}")
        Utils.wClick("left", this.x, this.y, 200)
    }

    Upgrade(upgradeAmount) {
        MacroGui.addProcess("Unit" this.unitSlot " (" this.x ", " this.y ") Level " this.level " -> " this.level + upgradeAmount)
        Roblox.Focus()
        Utils.wClick("left", this.x+this.xOffset, this.y+this.yOffset)

        loop upgradeAmount {
            SendInput("{t}")
            Sleep(200)
            this.level++
        }
    }

    Sell() {
        MacroGui.addProcess("Selling Unit (" this.x ", " this.y ")")
        Roblox.Focus()
        Utils.wClick("left", this.x+this.xOffset, this.y+this.yOffset)
        Sleep(200)
        SendInput("{x}")
    } 
}