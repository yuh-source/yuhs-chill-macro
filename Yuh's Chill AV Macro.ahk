#Requires AutoHotkey v2.0
#SingleInstance Force

$F1:: FullMacro()

$F4:: ExitGui(true)

$F3:: {
    FocusRoblox()
    if !MacroSetup(, false) {
        MsgBox("Failed Setup", "Keybind MacroSetup Error")
    }
}

$F2:: {
    ParagonCardPicker()
}

CoordMode('Mouse', 'Window')
CoordMode('Pixel', 'Window')
SendMode('Input')

global tinyTaskExists := false
global macroLoopCount := 0
global prevChallengeTime := A_Now
global psLinkFile := FileOpen(A_WorkingDir "\Settings\PSLink.txt", "r")
global webhookFile := FileOpen(A_WorkingDir "\Settings\DiscordWebhook.txt", "r")
global privRegex := "https:\/\/www\.roblox\.com(\/[a-z]{2})?\/games\/\d+\/[a-zA-Z0-9-]+(\?privateServerLinkCode=\d+)?"
global altPrivRegex := "https://www\.roblox\.com/share\?code=fa([0-9]+([A-Za-z]+[0-9]+)+)[A-Za-z]+&type=Server"
global globalDelay := 0
global inChallenge := false
global unlocked := false
global startTime := A_Now
global displayLoopCount := 1
global displayChallengeCount := 0

#Include "Gui\MacroGui.ahk"
#Include "Gui\GuiUtils.ahk"

#include "Scripts\CaptureScreen.ahk"
#Include "Scripts\DiscordWebhook.ahk"
#Include "Scripts\Classes.ahk"

#include "Scripts\MacroUtils.ahk"
#Include "Scripts\JoinStage.ahk"
#Include "Scripts\Macros.ahk"

#Include "Macros\PlanetNamek.ahk"
#Include "Macros\SandVillage.ahk"
#Include "Macros\DoubleDungeon.ahk"
#Include "Macros\ShibuyaStation.ahk"
#Include "Macros\ShibuyaAftermath.ahk"
#Include "Macros\Raid.ahk"


FullMacro() {

    AttemptJoin()

    if !ImageSearchLoop(playButtonPath, 60, 250, 125, 325, 500, 60) {
        InsertText(processText, "Cant Find Play Button")
        return FullMacro()
    }

    if !LobbyToLevel() {
        return FullMacro()
    }

    if !MacroStart() && autoRetry.Value {
        InsertText(processText, "Reloading Full Macro")
        return FullMacro()
    }
    return
}

; class test {

;     __Init() {
;         this.testvar := 0
;     }

;     static assignvar() {
;         SetTimer(capturePID, -1)
;         this.testreturn(&testvar)

;         capturePID(*) {
;             this.testvar := testvar
;         }
;     }

;     static testreturn(&testvar) {
;         testvar := 2
;     }
    
;     static readvar() {
;         MsgBox(this.testvar)
;     }
; }

; test.assignvar()
; Sleep(10)
; test.readvar()