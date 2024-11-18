#Requires AutoHotkey v2.0 
#SingleInstance Force

$F1:: Main()

$F4:: GuiMethods.Close(false)

$F3:: {
    Roblox.Focus()
    Setup.SetupTTask := true
    if !Setup.Run() {
        MsgBox("Failed Setup", "Keybind MacroSetup Error")
    }
    Setup.SetupTTask := false
}

$F2:: {
    Capture.Paragon()
}

CoordMode('Mouse', 'Window')
CoordMode('Pixel', 'Window')
SendMode('Input')
SetWinDelay(-1)

#Include lib\modules\Methods.ahk
#Include lib\modules\Gui.ahk
#Include lib\modules\Lobby.ahk
#Include lib\modules\Level.ahk
#Include lib\modules\Macro.ahk

#Include lib\modules\webhook\DiscordWebhook.ahk
#include lib\modules\rapidocr\RapidOcr.ahk
#include lib\modules\wincapture\wincapture.ahk

#Include "lib\macros\PlanetNamek.ahk"
#Include "lib\macros\SandVillage.ahk"
#Include "lib\macros\DoubleDungeon.ahk"
#Include "lib\macros\ShibuyaStation.ahk"
#Include "lib\macros\ShibuyaAftermath.ahk"
#Include "lib\macros\Raid.ahk"

MacroGui.Show()
Roblox.mv()

Main() {
    Macro.Join()

    if !Utils.ImageSearchLoop(Images.lobby.play, 60, 250, 125, 325, 500, 60) {
        MacroGui.addProcess("Cant Find Play Button")
        return Main()
    }

    if !Lobby.JoinLevel() {
        return Main()
    }

    if !Macro.initLoop() && MacroGui.ui["retryToggle"].Value {
        MacroGui.addProcess("Reloading Full Macro")
        return Main()
    }
}

; https://github.com/Descolada/OCR lightweight looks promising