#Requires AutoHotkey v2.0

MacroLoop() {
    InsertText(processText, userStage.Text userAct.Value)
    if raidToggle.value {
        if FileExist(A_ScriptDir "\TinyTask\Raid" userRaidAct.Value ".exe") != "" {
            local useTinyTask := RunTTask(A_ScriptDir "\TinyTask\Raid" userRaidAct.Value ".exe")
        } else {
            local useTinyTask := RunTTask(A_ScriptDir "\TinyTask\RaidStandard.exe")
        }
        
    } else {
        if FileExist(A_ScriptDir "\TinyTask\"  userStage.Text userAct.Value ".exe") != "" {
            local useTinyTask := RunTTask(A_ScriptDir "\TinyTask\"  userStage.Text userAct.Value ".exe")
        } else {
            local useTinyTask := RunTTask(A_ScriptDir "\TinyTask\"  userStage.Text "Standard.exe")
        }
    }

    RunTTask(programPath, isTinyTask := false) {
        try {
            global ttaskPID
            RunWait(programPath,,, &ttaskPID)
            return true
        } catch {
            return false
        }
    }

    if useTinyTask {
        InsertText(processText, "Finished " userstage.text userAct.Value ".exe")
    } else {
        try {
            stage := raidToggle.Value ? "Raid" : userStage.Text
            act := raidToggle.Value ? userRaidAct.Value : userAct.Value
            if RunActFunc(stage, act) {
                InsertText(processText, stage act " Done")
            } else {
                InsertText(processText, stage " Standard Done")
            }
        } catch {
            InsertText(processText, "Unable To Find Stage/Act")
        }
    }

    RunActFunc(stage, act) {
        try {
            %stage "Act" act%()
            return true
        } catch {
            %stage "Standard"%()
            return false
        }
    }

    if userAct.Value != 7 {
        if !ClickRewards() {
            return false
        }
    }

    if !ImageSearchLoop(returnLobbyButtonPath, 555, 440, 690, 470, 2000, 120) {
        InsertText(processText, "Cant Return To Lobby")
        return false
    }
    InsertText(processText, "Macro Ended")

    if webhookFile.Read() != "" {
        WindowCaptureToWebhook()
    }
    
    if (DateDiff(prevChallengeTime, A_Now, 'M') <= -30 and autoChallenges.Value) or (userCraftCrystals.Value && macroLoopCount >= 25) or macroLoopCount = maxLoops or inChallenge{
        ReturnToLobby()

        if !ImageSearchLoop(playButtonPath, 60, 250, 125, 325, 1000, 60) {
            InsertText(processText, "Cant Find Start")
        }
        return false
    }

    if userAct.Value = 8 {
        VoteStart(true, false)
        ParagonCardPicker(false)
        return VoteStart()
    }
    if !inChallenge {
        return VoteStart(true)
    }
    return false
}

MacroStart() {
    global maxLoops, macroLoopCount, displayLoopCount
    maxLoops := 50
    macroLoopCount := 1

    if !MacroSetup(true) {
        return false
    }

    while true {
        if !MacroLoop() {
            return false
        }
        macroLoopCount++
        displayLoopCount++
        displayLoops.Text := "Macro Loops: " displayLoopCount
    }
    return true
}
