#Requires AutoHotkey v2.0

MacroLoop() {
    InsertText(processText, userStage.Text userAct.Value)
    stagePath := raidToggle.value ? "\TinyTask\Raid" userRaidAct.Value ".exe" : "\TinyTask\" userStage.Text userAct.Value ".exe"
    standardPath := raidToggle.value ? "\TinyTask\RaidStandard.exe" : "\TinyTask\" userStage.Text "Standard.exe"
    local useTinyTask := RunTTask(A_ScriptDir (FileExist(A_ScriptDir stagePath) ? stagePath : standardPath))

    RunTTask(programPath) {
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
    
    if (DateDiff(prevChallengeTime, A_Now, 'M') <= -30 && autoChallenges.Value) 
        || (userCraftCrystals.Value && macroLoopCount >= 25) 
        || macroLoopCount = maxLoops 
        || inChallenge {
        ReturnToLobby()
        if !ImageSearchLoop(playButtonPath, 60, 250, 125, 325, 1000, 60)
            InsertText(processText, "Cant Find Start")
        return false
    }
    
    if userAct.Value = 8 {
        VoteStart(true, false), ParagonCardPicker(false)
        return VoteStart()
    }
    return !inChallenge ? VoteStart(true) : false
}

MacroStart() {
    global maxLoops := 50, macroLoopCount := 1
    if !MacroSetup(true)
        return false
    while MacroLoop() {
        displayLoops.Text := "Macro Loops: " ++displayLoopCount
        if ++macroLoopCount
            continue
    }
    return false
}
