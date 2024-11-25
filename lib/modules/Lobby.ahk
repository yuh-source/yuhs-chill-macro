#Requires AutoHotkey v2.0 

class Lobby {
    static prevChallengeTime := A_Now
    static inChallenge := false
    static currentStage := ""
    static currentAct := ""
    static raidType := ""

    static JoinLevel() {
        if MacroGui.ui["craftToggle"].Value && MacroGui.ui["legToggle"].Value {
            this.Crystals()
        }
    
        if DateDiff(this.prevChallengeTime, A_Now, 'M') <= -30  && MacroGui.ui["chalToggle"].Value {
            this.PreChal()

            if !Macro.initLoop() {
                this.PostChal()
            }
            return false
        }
    
        if MacroGui.ui["bossToggle"].Value {
            MacroGui.addProcess("Entering Boss Rush")
            this.Boss()
            return true
        }
    
        if MacroGui.ui["raidToggle"].Value || MacroGui.ui["spiritToggle"].Value  {
            MacroGui.ui["raidToggle"].Value ? this.raidType := "Raid" : this.raidType := "Spirit"
            MacroGui.addProcess("Entering " this.raidType)
            this.%this.raidType%()
            LobbyUI.SelectAct(MacroGui.ui["userRaidAct"].Value)
            return true
        }
        MacroGui.addProcess("Entering Teleporter")
        this.Level()
        MacroGui.addProcess("Stage: " MacroGui.ui["userStage"].Text)
        LobbyUI.SelectStage(MacroGui.ui["userStage"].Text)
        MacroGui.addProcess("Act: " MacroGui.ui["userAct"].Value)
        LobbyUI.SelectAct(MacroGui.ui["userAct"].Value)
        return true
    }

    static PreChal() {
        MacroGui.addProcess("Entering Challenge")
        this.prevChallengeTime := A_Now
        this.currentStage := MacroGui.ui["userStage"].Text
        this.currentAct := MacroGui.ui["userAct"].Value

        if MacroGui.ui["legToggle"].Value && !StrMethods.InArr("ShibuyaStation", ControlGetItems(MacroGui.ui["userStage"])) {
            MacroGui.ui["userStage"].Add("ShibuyaStation")
        }
        MacroGui.ui["userStage"].Text := this.Challenge()
        MacroGui.ui["userAct"].Value := 0

        Sleep(150)
        Utils.wClick("Left", 560, 470)
        MacroGui.addProcess(MacroGui.ui["userStage"].Text " Challenge")

        this.inChallenge := true
    }

    static PostChal() {
        MacroGui.ui["userStage"].Text := this.currentStage
        MacroGui.ui["userAct"].Value := this.currentAct
        if MacroGui.ui["legToggle"].Value && StrMethods.InArr("ShibuyaStation", ControlGetItems(MacroGui.ui["userStage"])) && this.inChallenge = true {
            MacroGui.ui["userStage"].Delete()
            MacroGui.ui["userStage"].Add(MacroGui.stageArrays[2])
        }
        this.inChallenge := false
        Macro.chalCount++
    }

    static Level() {
        Utils.wClick("Left", 100, 290)
        sleep(1000)
    
        SendInput("{w down}{d Down}")
    
        if !Utils.ImageSearchLoop(Images.lobby.stages, 100, 150, 250, 250, 1000, 30) {
            SendInput("{w up}{d up}")
            return this.Level()
        }
        SendInput("{w up}{d up}")
        return
    }

    static Raid() {
        this.AreaMenuTP("Raids")
        Sleep(1000)
    
        SendInput("{w down}")
        Sleep(1700)
        SendInput("{d Down}")
    
        if !Utils.ImageSearchLoop(Images.lobby.stages, 100, 150, 250, 250, 1000, 30) {
            SendInput("{w up}{d up}")
            return this.Raid()
        }
        SendInput("{w up}{d up}")
        return
    }

    static Spirit() {
        this.AreaMenuTP("Raids")
        Sleep(1000)
    
        SendInput("{w down}")
        Sleep(2500)
        SendInput("{d down}")
        Sleep(2500)
        SendInput("{d up}")
    
        if !Utils.ImageSearchLoop(Images.lobby.stages, 100, 150, 250, 250, 1000, 30) {
            SendInput("{w up}")
            return this.Spirit()
        }
        SendInput("{w up}")
        return
    }

    static Boss() {
        this.AreaMenuTP("Raids")
        Sleep(1000)
    
        SendInput("{s down}{d down}")
        Sleep(1200)
        SendInput("{s up}{d up}")
    
        SendInput("{e}")
        Sleep(200)
        Utils.wClick("Left", 210, 430)
    }

    static Challenge() {
        this.AreaMenuTP("Challenges")
        Sleep(1000)
    
        SendInput("{w down}")
        Sleep(1500)
        SendInput("{Space down}")
        Sleep(50)
        SendInput("{Space up}")
        Sleep(4000)
        SendInput("{w up}")
        SendInput("{d down}{s down}")
        Sleep(3000)
    
        for path, name in MacroGui.stageArrays {
            if Utils.ImageSearchLoop(Images.lobby.challenges[name], 490, 150, 620, 220, 500, 2) {
                MacroGui.addProcess("Found " name)
                SendInput("{d up}{s up}")
                return name
            }
        }
    
        Utils.wClick("Left", 710, 470)
        SendInput("{d up}{s up}")
        return Main()
    }

    static AreaMenuTP(area) {
        static areaCoords := {
            Challenges: [375, 300],
            Evolve: [540, 300],
            Raids: [540, 367]
        }
    
        Utils.wClick("Left", 40, 350)
        Sleep(300)
        MacroGui.addProcess("Teleporting to " area)
    
        if (areaCoords.HasOwnProp(area)) {
            coords := areaCoords.%area%
            Utils.wClick("Left", coords[1], coords[2])
            Sleep(150)
            Utils.wClick("Left", 570, 230, 150)
        }
    }

    static Crystals() {
        MacroGui.addProcess("Crafting Crystals")
        Roblox.Focus()
        this.AreaMenuTP("Evolve")
        SendInput("{w down}{d down}")
        Sleep(2500)
        SendInput("{w up}{d up}")
        Sleep(50)
        SendInput("{e}")
    
        Utils.wClick("Left", 270, 300)
        lobbyUI.CraftCrystals()
    }
}

class LobbyUI {
    static SelectStage(stageName) {
        if MacroGui.ui["legToggle"].Value {
            Utils.wClick("Left", 480, 515)
        }
        Sleep(150)
    
        For index, stage in MacroGui.stageArrays[MacroGui.ui["legToggle"].Value + 1] {
            if stageName = stage {
                Utils.wClick("Left", 200, (235 + (50*index)))
            }
        }
    }

    static SelectAct(actIndex) {
        Utils.wClick("Left", 430, 285)
        
        if actIndex <= 4 {
            loop 3 {
                SendInput("{WheelUp}")
                Sleep(50)
            }
            clickY := 220 + (50 * actIndex)
        } else {
            loop 3 {
                SendInput("{WheelDown}")
                Sleep(50)
            }
            clickY := 220 + (50 * (actIndex - 4))
        }
    
        Sleep(100)
        Utils.wClick("Left", 430, clickY, 50)
    
        if MacroGui.ui["userAct"].Value = 8 {
            SendInput("{Tab}")
            Sleep(500)
            Utils.wClick("Left", 780, 250)
        }
    
        Utils.wClick("Left", 370, 450)
        Sleep(100)
        Utils.wClick("Left", 560, MacroGui.ui["legToggle"].Value ? 500 : 460, 150)
    }

    static CraftCrystals() {
        Roblox.Focus()
        loop 5 {
            Utils.wClick("Left", 135 + (55*A_Index), 300)
    
            Utils.wClick("Left", 630, 330, 50)
            Sleep(150)
            SendInput("{3}")
            Sleep(50)
            Utils.wClick("Left", 580, 420)
            Sleep(200)
            Utils.wClick("Left", 400, 420)
    
            if Utils.ImageSearchLoop(Images.lobby.notEnoughItems, 370, 330, 440, 360, 200, 5) {
                Utils.wClick("Left", 400, 350)
                break
            }
        }
        Utils.wClick("Left", 490, 230)
    }
}