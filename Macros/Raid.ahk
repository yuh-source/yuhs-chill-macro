#Requires AutoHotkey v2.0

RaidStandard() {
    sleep(500)
    wagon1 := Unit(4, 200, 540)
    Sleep(40500)
    vegeta1 := Unit(3, 385, 425)
    Sleep(3000)
    vegeta2 := Unit(3, 45, 340)
    Sleep(15000)
    vegeta3 := Unit(3, 60, 370)
    Sleep(4000)
    wagon2 := Unit(4, 290, 520)
    wagon3 := Unit(4, 470, 480)
    Sleep(5000)
    vegeta4 := Unit(3, 110, 320)

    if macroLoopCount = 1 {
        if !ImageSearchLoop(raid10Path, 250, 50, 280, 67, 2500, 160) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            Return false
        }
    } else {
        if !ImageSearchLoop(raid10AltPath, 250, 95, 280, 113, 2500, 160) {
            MsgBox("Could not detect wave 15", "Detect Wave Error", "T5")
            return false
        }
    }
    Sleep(14000)
    wagon1.Upgrade(4)
    wagon2.Upgrade(4)
    wagon3.Upgrade(4)

    if macroLoopCount = 1 {
        if !ImageSearchLoop(raid15Path, 250, 50, 280, 67, 2500, 160) {
            MsgBox("Could not detect wave 15", "Detect Wave Error", "T5")
            Return false
        }
    } else {
        if !ImageSearchLoop(raid15AltPath, 250, 95, 280, 113, 2500, 160) {
            MsgBox("Could not detect wave 15", "Detect Wave Error", "T5")
            return false
        }
    }

    vegeta2.Upgrade(5)
    vegeta3.Upgrade(5)
    vegeta4.Upgrade(5)

    if macroLoopCount = 1 {
        if !ImageSearchLoop(raid20Path, 250, 50, 280, 67, 2000, 70) {
            MsgBox("Could not detect wave 20", "Detect Wave Error", "T5")
            Return false
        }
    } else {
        if !ImageSearchLoop(raid20AltPath, 250, 95, 280, 113, 2000, 70) {
            MsgBox("Could not detect wave 20", "Detect Wave Error", "T5")
            return false
        }
    }

    vegeta2.Upgrade(3)
    vegeta3.Upgrade(3)
    vegeta4.Upgrade(6)

    return
}