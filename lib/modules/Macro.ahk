#Requires AutoHotkey v2.0 

class Macro {
    static loopCount := 0
    static chalCount := 0
    static statTime := A_Now
}

class Lobby {
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