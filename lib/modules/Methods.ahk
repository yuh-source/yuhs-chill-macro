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

    static InsertText(ctrl, text) {
        ctrl.Value .= text "`n"
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