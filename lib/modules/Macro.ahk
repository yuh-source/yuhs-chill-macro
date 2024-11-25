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
            Roblox.Attach()
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
        stagePath := MacroGui.ui["raidToggle"].value || MacroGui.ui["spiritToggle"].Value ? "\TinyTask\" Lobby.raidType MacroGui.ui["userRaidAct"].Value ".exe" : "\TinyTask\" MacroGui.ui["userStage"].Text MacroGui.ui["userAct"].Value ".exe"
        standardPath := MacroGui.ui["raidToggle"].value || MacroGui.ui["spiritToggle"].Value ? "\TinyTask\" Lobby.raidType "Standard.exe" : "\TinyTask\" MacroGui.ui["userStage"].Text "Standard.exe"
        useTinyTask := TTaskMethods.Ctrl(A_ScriptDir (FileExist(A_ScriptDir stagePath) ? stagePath : standardPath))

        if useTinyTask {
            MacroGui.addProcess("Finished " MacroGui.ui["userStage"].text MacroGui.ui["userAct"].Value ".exe")
        } else {
            try {
                stage := MacroGui.ui["raidToggle"].Value || MacroGui.ui["spiritToggle"].Value ? Lobby.raidType : MacroGui.ui["userStage"].Text
                act := MacroGui.ui["raidToggle"].Value || MacroGui.ui["spiritToggle"].Value ? MacroGui.ui["userRaidAct"].Value : MacroGui.ui["userAct"].Value
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
            LevelUI.Start(true, false), Cards.Pick(false)
            return LevelUI.Start()
        }
        return LevelUI.Start(true)
    }
}

class Cards {
    static Pick(firstCard := true) {
        if firstCard {
            if !Utils.ImageSearchLoop(Images.level.stageInfo, 710, 395, 780, 415, 1000, 60) {
                MacroGui.addProcess("Cant Detect Stage Info")
            }

            Sleep(1000)

            if this.Search(&X, &Y, MacroGui.ui["spiritToggle"].Value ? MacroGui.spiritFPrio : MacroGui.modFPrio) {
                Utils.wClick("left", X, Y)
                this.clearMouse()
                firstCard := false
            }

            if MacroGui.ui["spiritToggle"].Value {
                MacroGui.addProcess("Picked First Card")
                return true
            }
        }
    
        while true {
            Sleep(1500)
            if this.Search(&X, &Y) {
                Utils.wClick("left", X, Y)
                this.clearMouse()
                continue
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

    static Search(&outX, &outY, prio := MacroGui.ui["spiritToggle"].Value ? MacroGui.spiritLPrio : MacroGui.modLPrio) {
        WinGetPos(&X, &Y, &W, &H, "ahk_exe RobloxPlayerBeta.exe")
        Plib := FindText()
        Slib := FindText()
        Plib.PicLib("|<champions>*19$60.UrzzzzzzzzDrzzzzzzzzTkwB8kvXVkTmNAUmP9YrTrPharPRilDrPharPRiwUrMBakP1iqlrQhqrvXilU|<dodge>*46$34.3zzjzw3zyTznDztzzSMQC71t9UkN7ZmvRYQr94aQ31UEM0yD/VkU|<drowsy>*17$39.7zzzzzsDzzzzzEzzzzzvU89YUQQ10UYt3UlY0V1M68UCA88sCF1X3jVnQCQ|<exploding>*19$55.1zzlzy1zzUzzszz4zzkzjwSzXzzcMU2A600A0A204100007342840E8TUW1420A40U08E806E0HcCAC2HA4|<fast>*18$49.0zzls3zzbzwswTzxks48C3UM8A0I70k004F3DUMk0S8lblwM1DUEks2AUjsMQS1iMM|<immunity>*18$49.zzzzzyBzjzzzzzgzrzzzzzyDs0E160E0s000300184kH9UkHUGN9YWN9s9AYm1AYARaqPYiL7A|<quake>*17$35.kzzyDy0zzwTwEzzszNt6E183mAU0E7YM810CAUE200840220MA4Y4|<regen>*18$35.Uzzzzy0zzzzwFrzxzsm30UUE00000000U0800F04MAUk88mtVkMPY|<revitalize>*18$55.3zzljy8zzUzzwXz6TzoRvzlzXzzP88m0E102000N000W20010WMUFX001kl4E8XUAUssV0U08CMSSskFM64|<shielded>*18$45.17XyDXzs8yTlwTz97zaDXbss4EFUEM1000A0160U0140186028U280kEEUEM1a23623Y|<strong>*18$36.1bzzzzDXzzzzD0231U1U211UsbAtAAQbSNQY1lS3QUXvT7RyU|<thrice>*18$35.0Fzlzy0XzrzzD7zzzyT1U88Ay32EGNwmRD4nvZvDDbr/q23jiriC4", true)
        Slib.PicLib("|<fisticuffs>*23$51.07ylzzl7s1zbTzw8zDzwTzzWDsMV081U0k10c10A04E8Va1lYlkD64ED8aD1s0U884lUDYC9XUbC4|<notrait>*22$44.STz0DzXHbzk1zxYNzzXzzs2MDtUU0061yM800V6TaAE98F7sX42363y8s0UtkzbD1AU|<kings>*12$31.Q7zzTYLzzDkTzzbsM0k+4A086+61UXV10kFs40N0k31AkQA|<warding>*24$46.QvzzsDzwn7zzZzzm4zzyTzz8G0200A0080800E814340M8X4EAE1UWAM0s06EAnkHkGNUU|<money>*30$38.7Xzzzzkkzzzzw48862Q0200UG1463044P10k3V7m2AUsvwkrADC", true)

        for i in prio {
            try {
                ok := FindText(&outX, &outY, X + 220, Y + 270, X + 500, Y + 300,,, MacroGui.ui["spiritToggle"].Value ? Slib.PicLib(i) : Plib.PicLib(i))
                if ok[1].id := i  {
                    return true
                }
                return false
            }
        }
    }

    static ClearMouse() {
        Sleep(50)
        MouseMove(410, 470)
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