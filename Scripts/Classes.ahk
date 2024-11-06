#Requires AutoHotkey v2.0

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
        InsertText(processText, "Placing Unit " this.unitSlot " at (" this.x ", " this.y ")")
        FocusRoblox()
        SendInput("{" this.unitSlot "}")
        TpMouse("left", this.x, this.y, 200)
    }

    Upgrade(upgradeAmount) {
        InsertText(processText, "Unit" this.unitSlot " (" this.x ", " this.y ") Level " this.level " -> " this.level + upgradeAmount)
        FocusRoblox()
        TpMouse("left", this.x+this.xOffset, this.y+this.yOffset)

        loop upgradeAmount {
            SendInput("{t}")
            Sleep(200)
            this.level++
        }
    }

    Sell() {
        InsertText(processText, "Selling Unit (" this.x ", " this.y ")")
        FocusRoblox()
        TpMouse("left", this.x+this.xOffset, this.y+this.yOffset)
        Sleep(200)
        SendInput("{x}")
    } 
}

class MacroGui extends Gui {
    CreateTitleGroupBox(textColour, x, y, boxTitle, w := 420, h := 60, fontSize := 10) {
        this.SetFont(Format("s{}", fontSize))
    
        this.AddGroupBox(Format("c{} x{} y{} w{} h{}", textColour, x, y, w, h), boxTitle)
    
        this.SetFont("s8") ; default font size
    }
}