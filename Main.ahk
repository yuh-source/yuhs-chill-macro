#Requires AutoHotkey v2.0 
#SingleInstance Force

$F1:: Main()

$F4:: GuiMethods.Close(true)

$F3:: {
    Roblox.Focus()
    Setup.SetupTTask := true
    if !Setup.Run() {
        MsgBox("Failed Setup", "Keybind MacroSetup Error")
    }
    Setup.SetupTTask := false
}

$F2:: {
    Paragon.Pick()
}

CoordMode('Mouse', 'Window')
CoordMode('Pixel', 'Window')
SendMode('Input')

#Include lib\modules\Methods.ahk
#Include lib\modules\Gui.ahk
#Include lib\modules\Lobby.ahk
#Include lib\modules\Macro.ahk
#Include lib\modules\Level.ahk

#Include lib\webhook\DiscordWebhook.ahk

MacroGui.Show()

Main() {
    Macro.Join()

    if !Utils.ImageSearchLoop(Images.lobby.play, 60, 250, 125, 325, 500, 60) {
        MacroGui.addProcess("Cant Find Play Button")
        return Main()
    }

    if !Lobby.JoinLevel() {
        return Main()
    }

    if !Macro.initLoop() && MacroGui.ui[""].Value {
        MacroGui.addProcess("Reloading Full Macro")
        return Main()
    }
}