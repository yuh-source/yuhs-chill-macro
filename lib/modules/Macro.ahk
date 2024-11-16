#Requires AutoHotkey v2.0 

class Macro {
    static loopCount := 0
    static chalCount := 0
    static startTime := A_Now
}

class Lobby {
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

    static Boss() {
        this.AreaMenuTP("Raids")
        Sleep(1000)
    
        SendInput("{s down}{d down}")
        Sleep(1200)
        SendInput("{s up}{d up}")
    
        SendInput("{e}")
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
            if Utils.ImageSearchLoop(%"Images.lobby.challenges." name%, 490, 150, 620, 220, 500, 2) {
                MacroGui.addProcess("Found " name)
                SendInput("{d up}{s up}")
                return name
            }
        }
    
        Utils.wClick("Left", 710, 470)
        SendInput("{d up}{s up}")
        return ; FullMacro()
    }

    static AreaMenuTP(area) {
        static areaCoords := {
            Challenges: [375, 300],
            Evolve: [540, 300],
            Raids: [540, 367]
        }
    
        Utils.wClick("Left", 40, 350)
        Sleep(150)
        MacroGui.addProcess("Teleporting to " area)
    
        if (areaCoords.HasOwnProp(area)) {
            coords := areaCoords.%area%
            Utils.wClick("Left", coords[1], coords[2])
            Sleep(150)
            Utils.wClick("Left", 570, 230, 150)
        }
    }

    static Crystals() {
        Roblox.Focus()
        this.AreaMenuTP("Evolve")
        SendInput("{w down}{d down}")
        Sleep(2500)
        SendInput("{w up}{d up}")
        Sleep(50)
        SendInput("{e}")
    
        Utils.wClick("Left", 270, 300)
        this.CraftCrystals()
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