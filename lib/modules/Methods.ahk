#Requires AutoHotkey v2.0 

class GuiMethods extends Gui {
    static Close(exit := true) {
        TTaskMethods.Ctrl(, true)
        if exit {
            if WinExist("ahk_exe RobloxPlayerBeta.exe") {
                WinMove(7, 21, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
            }
            return ExitApp()
        }
        reload()
        Sleep(500)
    }

    static ChangeDDl(ctrl, arrays, toggle := 0) { ; ChangeDDl(useract, MacroGui.actArrays, legendStageToggle.Value)
        cIndex := ctrl.Value
        ctrl.Delete(), ctrl.Add(arrays[toggle + 1])
        (cIndex > arrays[toggle + 1].Length) ? ctrl.Choose(1) : ctrl.Choose(cIndex)
    }

    AddTitleGroupBox(textColour, x, y, boxTitle, w := 420, h := 60, fontSize := 10) {
        this.SetFont("s" fontSize)
        this.AddGroupBox("c" textColour " x" x " y" y " w" w " h" h, boxTitle)
        this.SetFont("s8")
    }
}

class FileMethods {
    static Read(filePath) {
        return FileExist(filePath) ? FileRead(filePath) : ""
    }

    static Write(filePath, text) {
        FileDelete(filePath)
        FileAppend(text, filePath)
    }
}

class StrMethods {
    static Contains(str, substr) {
        return InStr(str, substr) ? true : false
    }

    static Matches(str, regex) {
        return RegExMatch(str, regex) ? true : false
    }

    static InArr(str, arr) {
        for key, value in arr
            if (value == str)
                return true
        return false
    }
}

class TTaskMethods {
    static Ctrl(ttPath := "", kill := false) {
        static PID := ""
        if !kill {
            try {
                RunWait(ttPath,,, &PID)
                return true
            } catch {
                return false
            }
        }
        try {
            ProcessClose(PID)
            return
        }
    }
}

class Images {
    static lobby := {
        play: "*75 " A_ScriptDir "\Images\Lobby\Play Button.png",
        stages: "*100 " A_ScriptDir "\Images\Lobby\Stages.png",
        notEnoughItems: "*100 " A_ScriptDir "\Images\Lobby\Not Enough Items.png",
        
        challenges: {
            planetNamek: "*100 " A_ScriptDir "\Images\Lobby\PlanetNamek Challenge Banner.png",
            sandVillage: "*100 " A_ScriptDir "\Images\Lobby\SandVillage Challenge Banner.png",
            doubleDungeon: "*100 " A_ScriptDir "\Images\Lobby\DoubleDungeon Challenge Banner.png",
            shibuyaStation: "*100 " A_ScriptDir "\Images\Lobby\ShibuyaStation Challenge Banner.png"
        }
    }

    static level := {
        voteStart: "*75 " A_ScriptDir "\Images\Level Elements\Vote Start.png",
        returnToLobby: "*100 " A_ScriptDir "\Images\Level Elements\Return To Lobby Button.png",
        gemsReward: "*75 " A_ScriptDir "\Images\Level Elements\Gems Reward.png",
        stageInfo: "*50 " A_ScriptDir "\Images\Level Elements\Stage Info.png",
        settings: "*160 " A_ScriptDir "\Images\Level Elements\Settings Icon.png",

        paragon: this.InitParagonMap()
    }

    static InitParagonMap() {
        mp := Map()
        Loop MacroGui.modArray.Length {
            mp[MacroGui.modArray[A_Index]] := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\" MacroGui.modArray[A_Index] ".png"
        }
        return mp
    }
}