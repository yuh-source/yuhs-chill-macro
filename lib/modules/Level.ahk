#Requires AutoHotkey v2.0 

Class LevelUI {
    static Start(checkLobby := false) {
        if checkLobby {
            if !Utils.ImageSearchLoop(Images.level.returnToLobby, 555, 440, 690, 470, 500, 20) {
                MacroGui.addProcess("Unable To Return To Lobby")
                return false
            }
            if MacroGui.ui["userAct"].Value = 8 {
                Utils.wClick("Left", 230, 450)
                if Utils.ImageSearchLoop(Images.level.returnToLobby, 555, 440, 690, 470, 500, 4) {
                    MacroGui.addProcess("Paragon Fail Detected")
                    Utils.wClick("Left", 620, 460)
    
                    if !Utils.ImageSearchLoop(Images.lobby.play, 60, 250, 125, 325, 1000, 60) {
                        MacroGui.addProcess("Cant Find Start")
                    }
                    return false
                }
            } else {
                Utils.wClick("Left", 500, 450)
            }
        }
        if !Utils.ImageSearchLoop(Images.level.voteStart, 370, 115, 440, 130, 500) {
            MacroGui.addProcess("Cant Find Vote Start")
            return false
        }
        MacroGui.addProcess("Found Vote Start")
        ; if clickstart { ###########################################################
            Utils.wClick("Left", 375, 155)
        ; }
        return true
    }

    static MiscSettings(button := "Spawn") {
        Utils.wClick("Left", 25, 610)
        Sleep(300)
        if button = "Spawn" {
            Utils.wClick("Left", 525, 240)
        }
        else if button = "Lobby" {
            Utils.wClick("Left", 525, 280)
            Sleep(150)
            Utils.wClick("Left", 355, 340)
            return
        }
        Sleep(150)
        Utils.wClick("Left", 580, 160)
        Sleep(500)
    }
}

Class Setup {
    static LookDown() {
        MouseGetPos(&x, &y)
        SendInput("{Click " x " " y " Right}")
        Sleep(100)
        SendInput("{Click " x " " y " Right down}")
        Sleep(100)
        SendInput("{Click " x " " y+100 " Right up}")
    }

    static Standard() {
        SendInput("{Tab}")
        LevelUI.MiscSettings()
        Sleep(750)
        loop 10 {
            SendInput("{WheelDown}")
            Sleep(50)
        }
        Sleep(100)
    }
    
    static Raid() {
        this.Standard()
    
        SendInput("{w down}")
        Utils.DllSleep(300)
        SendInput("{d down}")
        Utils.DllSleep(550)
        SendInput("{w up}{d up}")
        Sleep(100)
    
        SendInput("{Right down}")
        Utils.DllSleep(1470)
        SendInput("{Right up}")
        Sleep(100)
    
        this.LookDown()
        return LevelUI.Start()
    }
    
    static PlanetNamek() {
        this.Standard()
        this.LookDown()
        return LevelUI.Start()
    }
    
    static SandVillage() {
        this.Standard()
        this.LookDown()
    
        Sleep(150)
        SendInput('{Left down}')
        Utils.DllSleep(310)
        SendInput('{Left up}')
        return LevelUI.Start()
    }
    
    static DoubleDungeon() {
        this.Standard()
    
        SendInput("{v}")
        Sleep(250)
        SendInput("{a down}")
        Sleep(2000)
        SendInput("{a up}")
    
        SendInput("{v}")
        Sleep(250)
        SendInput("{d Down}")
        Sleep(400)
        SendInput("{d up}")
    
    
        SendInput('{Right down}')
        Utils.DllSleep(750)
        SendInput('{Right up}')
        return LevelUI.Start()
    }
    
    static ShibuyaStation() {
        this.Standard()
        return LevelUI.Start()
    }
    
    static ShibuyaAftermath() {
        this.Standard()
    
        SendInput("{a down}")
        Sleep(800)
        SendInput("{a up}")
    
        SendInput('{Left down}')
        Utils.DllSleep(500)
        SendInput('{Left up}')
        return LevelUI.Start()
    }  
}