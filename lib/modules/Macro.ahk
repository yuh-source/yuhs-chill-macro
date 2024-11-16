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
            ; OpenMiscSettings("Lobby") ######################################
            return false
        } else {
            MacroGui.addProcess("Selected All Modifiers")
            return true
        }
    }
}