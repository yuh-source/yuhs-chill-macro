#Requires AutoHotkey v2.0

global playButtonPath := "*75 " A_ScriptDir "\Images\Lobby\Play Button.png"
global stageBannerPath := "*100 " A_ScriptDir "\Images\Lobby\Stages.png"
global notEnoughItemsPath := "*100 " A_ScriptDir "\Images\Lobby\Not Enough Items.png"

global planetNamekChallengePath := "*100 " A_ScriptDir "\Images\Lobby\PlanetNamek Challenge Banner.png"
global sandVillageChallengePath := "*100 " A_ScriptDir "\Images\Lobby\SandVillage Challenge Banner.png"
global doubleDungeonChallengePath := "*100 " A_ScriptDir "\Images\Lobby\DoubleDungeon Challenge Banner.png"
global shibuyaStationChallengePath := "*100 " A_ScriptDir "\Images\Lobby\ShibuyaStation Challenge Banner.png"

global voteStartPath := "*75 " A_ScriptDir "\Images\Level Elements\Vote Start.png"
global returnLobbyButtonPath := "*100 " A_ScriptDir "\Images\Level Elements\Return To Lobby Button.png"
global gemsRewardPath := "*75 " A_ScriptDir "\Images\Level Elements\Gems Reward.png"

global namek10Path := "*100 " A_ScriptDir "\Images\Level Elements\Planet Namek\Namek Wave 10.png"
global namek10AltPath := "*100 " A_ScriptDir "\Images\Level Elements\Planet Namek\Namek Wave 10 Alt.png"

global raid10Path := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 10.png"
global raid10AltPath := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 10 Alt.png"
global raid15Path := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 15.png"
global raid15AltPath := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 15 Alt.png"
global raid20Path := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 20.png"
global raid20AltPath := "*100 " A_ScriptDir "\Images\Level Elements\Raid\Raid Wave 20 Alt.png"

global thricePath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\thrice.png"
global strongPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\strong.png"
global regenPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\regen.png"
global shieldedPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\shielded.png"
global explodingPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\exploding.png"
global fastPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\fast.png"
global revitalisePath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\revitalise.png"
global quakePath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\quake.png"
global championsPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\champions.png"
global dodgePath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\dodge.png"
global drowsyPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\drowsy.png"
global immunityPath := "*25 " A_ScriptDir "\Images\Level Elements\Paragon\immunity.png"

global stageInfoPath := "*50 " A_ScriptDir "\Images\Level Elements\Stage Info.png"
global settingsPath := "*160 " A_ScriptDir "\Images\Level Elements\Settings Icon.png"

; refactor above paths

TpMouse(button, x, y, clickDelay := 0) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(clickDelay + globalDelay)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

DllSleep(lPeriod) {
    ; DllCall("Winmm\timeBeginPeriod", "UInt", 7)

    ; DllCall("Sleep", "UInt", lPeriod)

    ; DllCall("Winmm\timeEndPeriod", "UInt", 7)

    if (hTimer := DllCall("CreateWaitableTimerExW", "ptr", 0, "ptr", 0, "uint", 3, "uint", 0x1F0003, "uptr"))
		&& DllCall("SetWaitableTimer", "uptr", hTimer, "uint64*", lPeriod * -10000, "int", 0, "ptr", 0, "ptr", 0, "int", 0)
		DllCall("WaitForSingleObject", "uptr", hTimer, "UInt", 0xFFFFFFFF), DllCall('CloseHandle', "uptr", hTimer)
}

FocusRoblox() {
    loop 15 {
        if WinExist("ahk_exe RobloxPlayerBeta.exe") {
            WinActivate("ahk_exe RobloxPlayerBeta.exe")
            return true
        }
        Sleep(1000)
    }
    InsertText(processText, "Cant Find Roblox")
    AttemptJoin()
    return false
}

ImageSearchLoop(imagePath, Xtl, Ytl, Xbr, Ybr, searchDelay := 1000, maxRetryCount := 15, &FoundX := 0, &FoundY := 0) {
    static coordSet := CoordMode("Pixel", "Window")  ; Set once, static
    
    loop maxRetryCount + 1 {
        if !FocusRoblox()
            return false
            
        if ImageSearch(&FoundX, &FoundY, Xtl, Ytl, Xbr, Ybr, imagePath)
            return true
            
        DllSleep(searchDelay)
    }
    return false
}

ClickRewards(rewardAmount := 10) {
    loop 80 {
        Sleep(2000)
        if !ImageSearchLoop(settingsPath, 15, 595, 40, 625, 500, 2) {
            InsertText(processText, "Found Rewards")
            break
        }
    }

    InsertText(processText, "Clicking Rewards")
    loop rewardAmount {
        TpMouse("Left", 400, 340)
        Sleep(700)
    }

    if ImageSearchLoop(returnLobbyButtonPath, 555, 440, 690, 470, 500, 4) {
        return true
    }
    return false
}

AreaMenuTP(area) {
    static areaCoords := {
        Challenges: [375, 300],
        Evolve: [540, 300],
        Raids: [540, 370]
    }

    TpMouse("Left", 40, 350)
    Sleep(150)
    InsertText(processText, "Teleporting to " area)

    if coords := areaCoords.HasOwnProp(area) ? areaCoords[area] : false {
        TpMouse("Left", coords[1], coords[2])
        TpMouse("Left", 570, 230, 150)
    }
    return
}

OpenMiscSettings(button := "Spawn") {
    TpMouse("Left", 25, 610)
    Sleep(300)
    if button = "Spawn" {
        TpMouse("Left", 525, 240)
    }
    else if button = "Lobby" {
        TpMouse("Left", 525, 280)
        Sleep(150)
        TpMouse("Left", 355, 340)
        return
    }
    Sleep(150)
    TpMouse("Left", 580, 160)
    Sleep(500)
}

OpenCrystalCrafting() {
    FocusRoblox()
    AreaMenuTP("Evolve")
    SendInput("{w down}{d down}")
    Sleep(2500)
    SendInput("{w up}{d up}")
    Sleep(50)
    SendInput("{e}")

    TpMouse("Left", 270, 300)
}

CraftCrystals() {
    FocusRoblox()
    loop 5 {
        TpMouse("Left", 135 + (55*A_Index), 300)

        TpMouse("Left", 630, 330, 50)
        Sleep(150)
        SendInput("{3}")

        Sleep(50)
        TpMouse("Left", 580, 420)
        Sleep(200)
        TpMouse("Left", 400, 420)

        if ImageSearchLoop(notEnoughItemsPath, 370, 330, 440, 360, 200, 5) {
            TpMouse("Left", 400, 350)
            break
        }
    }

    TpMouse("Left", 490, 230)
}

LookDown() {
    MouseGetPos(&x, &y)
    SendInput(Format("{Click {} {} Right}", x, y))
    Sleep(100)
    SendInput(Format("{Click {} {} Right down}", x, y))
    Sleep(100)
    SendInput(Format("{Click {} {} Right up}", x, y+100))
}

ParagonCardPicker(firstCard := true) {
    if firstCard {
        if !ImageSearchLoop(stageInfoPath, 710, 395, 780, 415, 1000, 60) {
            InsertText(processText, "Cant Detect Stage Info")
        }
        Sleep(3000)
    }

    while true {
        cardFound := false
        Sleep(1500)
        for modifier in cardOrder {
            if ImageSearchLoop(%modifier "Path"%, 190, 270, 620, 305, 0, 2, &X, &Y) {
                TpMouse("left", X, Y)
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
        InsertText(processText, "First Card Was Bad")
        OpenMiscSettings("Lobby")
        return false
    } else {
        InsertText(processText, "Selected All Modifiers")
        return true
    }
}
