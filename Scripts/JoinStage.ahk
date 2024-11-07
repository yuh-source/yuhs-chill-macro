#Requires AutoHotkey v2.0

AttemptJoin() {
    if ReturnToLobby() {
        InsertText(processText, "Attatching to Roblox")
        FocusRoblox()
        WinGetPos(&X, &Y,,, ui)
        WinMove(X - 8, Y + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
    } else {
        JoinGame()
    }
}

ReturnToLobby() {
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        if ImageSearchLoop(returnLobbyButtonPath, 555, 440, 690, 470, 500, 2) {
            InsertText(processText, "Found Return To Lobby")
            TpMouse("Left", 620, 460)
        } else if ImageSearchLoop(settingsPath, 15, 595, 40, 625, 500, 2) {
            InsertText(processText, "Found Settings Button")
            OpenMiscSettings("Lobby")
        }
        return true
    }
    return false
}

JoinGame() {
    InsertText(processText, "Cant Find Roblox")
    JoinServer()
    WinWait("ahk_exe RobloxPlayerBeta.exe")

    InsertText(processText, "Attatching to Roblox")
    FocusRoblox()
    WinRestore("ahk_exe RobloxPlayerBeta.exe")

    WinGetPos(&X, &Y,,, ui)
    WinMove(X - 8, Y + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
    return
}

JoinServer() {
    if usePriv {
        if psLink.Text ~= privRegex or psLink.Text ~= altPrivRegex{
            InsertText(processText, "Joining Set Private Server")
            return Run(psLink.Text)
        }   else {
            InsertText(processText, "Invalid Private Server")
            return
        }
    } else {
        InsertText(processText, "Waiting For User To Join Roblox")
        return run("https://www.roblox.com/games/16146832113/UPDATE-0-5-Anime-Vanguards")
    }
}
; https://www.roblox.com/games/16146832113/RELEASE-Anime-Vanguards?privateServerLinkCode=28074937708422366185152340790991

EnterTeleporter() {
    TpMouse("Left", 100, 290)
    sleep(1000)

    SendInput("{w down}{d Down}")

    if !ImageSearchLoop(stageBannerPath, 100, 150, 250, 250, 1000, 30) {
        SendInput("{w up}{d up}")
        return EnterTeleporter()
    }
    SendInput("{w up}{d up}")
    return
}

EnterRaid() {
    AreaMenuTP("Raids")
    Sleep(1000)

    SendInput("{w down}")
    Sleep(1700)
    SendInput("{d Down}")

    if !ImageSearchLoop(stageBannerPath, 100, 150, 250, 250, 1000, 30) {
        SendInput("{w up}{d up}")
        return EnterRaid()
    }
    SendInput("{w up}{d up}")
    return
}

EnterChallenge() {
    AreaMenuTP("Challenges")
    Sleep(1000)

    SendInput("{w down}")
    Sleep(1500)
    SendInput("{Space down}")
    Sleep(50)
    SendInput("{Space up}")
    Sleep(4000)
    SendInput("{w up}")
    SendInput("{d down}{s down}")
    Sleep(3000)
    if ImageSearchLoop(planetNamekChallengePath, 490, 150, 620, 220, 500, 2) {
        InsertText(processText, "Found PlanetNamek")
        SendInput("{d up}{s up}")
        return "PlanetNamek"
    }
    else if ImageSearchLoop(sandVillageChallengePath, 490, 150, 620, 220, 500, 2) {
        InsertText(processText, "Found SandVillage")
        SendInput("{d up}{s up}")
        return "SandVillage"
    }
    else if ImageSearchLoop(doubleDungeonChallengePath, 490, 150, 620, 220, 500, 2) {
        InsertText(processText, "Found DoubleDungeon")
        SendInput("{d up}{s up}")
        return "DoubleDungeon"
    }
    else if ImageSearchLoop(shibuyaStationChallengePath, 490, 150, 620, 220, 500, 2) {
        InsertText(processText, "Found ShibuyaStation")
        SendInput("{d up}{s up}")
        return "ShibuyaStation"
    }
    TpMouse("Left", 710, 470)
    SendInput("{d up}{s up}")
    return FullMacro()
}

SelectStage(stageName, stageArray, arrayToggle := false) {
    if arrayToggle {
        TpMouse("Left", 480, 515)
    }

    Sleep(150)

    For index, stage in stageArray {
        if stageName = stage {
            TpMouse("Left", 200, (235 + (50*index)))
        }
    }
    return
}

SelectAct(actIndex, arrayToggle := false) {
    TpMouse("Left", 430, 285)
    if actIndex <= 4 {
        loop 3 {
            SendInput("{WheelUp}")
            Sleep(50)
        }
        local clickIndex := actIndex
    }
    else if actIndex > 4 {
        loop 3 {
            SendInput("{WheelDown}")
            Sleep(50)
        }
        local clickIndex := actIndex - 4
    }

    Sleep(100)
    TpMouse("Left", 430, 220 + (50*clickIndex), 50)

    if userAct.Value = 8 {
        SendInput("{Tab}")
        Sleep(500)

        TpMouse("Left", 780, 250)
    }

    TpMouse("Left", 370, 450)

    Sleep(200)

    if !arrayToggle {
        TpMouse("Left", 560, 460, 150)
    } else {
        TpMouse("Left", 560, 500, 150)
    }
    return
}

LobbyToLevel() {
    if userCraftCrystals.Value && legendStageToggle.Value {
        InsertText(processText, "Crafting Crystals")
        Sleep(500)
        OpenCrystalCrafting()
        CraftCrystals()
    }

    if DateDiff(prevChallengeTime, A_Now, 'M') <= -30  && autoChallenges.Value {
        global displayChallengeCount
        static currentStage, currentAct

        InsertText(processText, "Entering Challenge")
        global prevChallengeTime := A_Now
        currentStage := userStage.Text
        currentAct := userAct.Value

        if legendStageToggle.Value and !StrInlist("ShibuyaStation", ControlGetItems(userStage)) {
            userStage.Add("ShibuyaStation")
        }
        userStage.Text := EnterChallenge() ; can only select from current ddl options, currently a bug when finding shibuyaStation when u have legend stage on (because its not in ddl)
        userAct.Value := 0
        ; make the act number = 0 for challenges :D

        Sleep(150)
        TpMouse("Left", 560, 470)
        InsertText(processText, userStage.Text " Challenge")

        global inChallenge := true

        if !MacroStart() {
            userStage.Text := currentStage
            userAct.Value := currentAct
            if legendStageToggle.Value and StrInlist("ShibuyaStation", ControlGetItems(userStage)) and inChallenge = true{
                userStage.Delete()
                userstage.Add(stageArrays[2])
            }
            inChallenge := false
            displayChallengeCount++
            challengesCompleted.Text := "Challenges Done: " displayChallengeCount
        }
        return false
    }

    if raidToggle.Value {
        InsertText(processText, "Entering Raid")
        EnterRaid()
        SelectAct(userRaidAct.Value)
        return true
    }
    InsertText(processText, "Entering Teleporter")
    EnterTeleporter()
    InsertText(processText, "Stage: " userStage.Text)
    SelectStage(userStage.Text, stageArrays[legendStageToggle.Value + 1], legendStageToggle.Value)
    InsertText(processText, "Act: " userAct.Value)
    SelectAct(userAct.Value, legendStageToggle.Value)
    return true
}

VoteStart(checkLobbyButton := false, clickStart := true) {
    if checkLobbyButton {
        if !ImageSearchLoop(returnLobbyButtonPath, 555, 440, 690, 470, 500, 20) {
            InsertText(processText, "Unable To Return To Lobby")
            return false
        }
        if userAct.Value = 8 {
            TpMouse("Left", 230, 450)
            if ImageSearchLoop(returnLobbyButtonPath, 555, 440, 690, 470, 500, 4) {
                InsertText(processText, "Paragon Fail Detected")
                TpMouse("Left", 620, 460)

                if !ImageSearchLoop(playButtonPath, 60, 250, 125, 325, 1000, 60) {
                    InsertText(processText, "Cant Find Start")
                }
                return false
            }
        } else {
            TpMouse("Left", 500, 450)
        }
    }
    if !ImageSearchLoop(voteStartPath, 370, 115, 440, 130, 500) {
        InsertText(processText, "Cant Find Vote Start")
        return false
    }
    InsertText(processText, "Found Vote Start")
    if clickStart {
        TpMouse("Left", 375, 155)
    }
    return true
}

MacroSetup(startButtonCheck := false, clickStart := true) {

    if userAct.Value = 8 {
        if !ParagonCardPicker() {
            return false
        }
    }

    if startButtonCheck {
        if !ImageSearchLoop(voteStartPath, 370, 115, 440, 130, , 30) {
            InsertText(processText, "Cant Find Vote Start")
            return false
        }
    }

    if raidToggle.Value {
        raidSetup(clickStart)
        return true
    } else {
        try {
            %userstage.text "Setup"%(clickStart)
            return true
        }
    }

    InsertText(processText, "No Valid Macro Setup")
    return false
}

RaidSetup(clickStart) {
    InsertText(processText, "Raid Setup")
    SendInput("{Tab}")
    OpenMiscSettings()
    Sleep(750)
    SendInput("{w down}")
    DllSleep(300)
    SendInput("{d down}")
    DllSleep(550)
    SendInput("{w up}{d up}")
    Sleep(100)

    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }

    SendInput("{Right down}")
    DllSleep(1470)
    SendInput("{Right up}")
    Sleep(100)

    LookDown()
    
    return VoteStart(, clickStart)
}

PlanetNamekSetup(clickStart) {
    InsertText(processText, userstage.text " Setup")
    SendInput("{Tab}")
    OpenMiscSettings()
    Sleep(750)
    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }
    Sleep(100)
    LookDown()
    return VoteStart(, clickStart)
}

SandVillageSetup(clickStart) {
    InsertText(processText, userstage.text " Setup")
    SendInput("{Tab}")
    OpenMiscSettings()
    Sleep(750)
    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }
    LookDown()
    Sleep(150)
    SendInput('{Left down}')
    DllSleep(310)
    SendInput('{Left up}')
    return VoteStart(, clickStart)
}

DoubleDungeonSetup(clickStart) {
    InsertText(processText, userstage.text " Setup")
    SendInput("{Tab}")
    Sleep(750)
    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }
    return VoteStart(, clickStart)
}

ShibuyaStationSetup(clickStart) {
    InsertText(processText, userstage.text " Setup")
    SendInput("{Tab}")
    OpenMiscSettings()
    Sleep(750)

    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }
    return VoteStart(, clickStart)
}

ShibuyaAftermathSetup(clickStart) {
    InsertText(processText, userstage.text " Setup")
    SendInput("{Tab}")
    OpenMiscSettings()
    Sleep(750)

    SendInput("{a down}")
    Sleep(800)
    SendInput("{w down}")
    Sleep(4000)
    SendInput("{w up}{a up}")

    loop 10 {
        SendInput("{WheelDown}")
        Sleep(50)
    }
    return VoteStart(, clickStart)
}  