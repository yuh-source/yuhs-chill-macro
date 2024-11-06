#Requires AutoHotkey v2.0

PlanetNamekAct7() {
    Sleep(1000)
    vegeta1 := Unit(3, 600, 380)
    vegeta2 := Unit(3, 690, 300)

    Sleep(20000)

    vegeta2.Upgrade(2)

    Sleep(10000)
    
    vegeta1.Upgrade(1)

    if macroLoopCount = 1 {
        if !ImageSearchLoop(namek10Path, 250, 50, 280, 67, 2000, 120) { ;120 retrys = 4 mins, wave 10 should start 3:30
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    } else {
        if !ImageSearchLoop(namek10AltPath, 250, 95, 280, 113, 2000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    }

    sasuke1 := Unit(2, 660, 420)

    Sleep(35000) ; Boss should spawn around 15000

    sasuke1.Sell()

    vegeta2.Upgrade(8)
    return
}

PlanetNamekAct8() {
    wagon1 := Unit(4, 760, 480, 5, 0)
    wagon2 := Unit(4, 670, 480, 5, 0)
    wagon3 := Unit(4, 600, 480, 5, 0)

    Sleep(3000)

    wagon3.Upgrade(1)

    Sleep(1000)

    sasuke1 := unit(2,  700, 300, 10, 0)
    sasuke2 := Unit(2, 645, 300, 5, 0)
    vegeta1 := Unit(3, 405, 420)

    Sleep(15000)

    sasuke3 := Unit(2, 585, 300)
    vegeta2 := Unit(3, 645, 385)

    Sleep(3000)

    vegeta3 := Unit(3, 470, 340)
    vegeta4 := Unit(3, 585, 385)

    croc1 := Unit(5, 480, 380)

    Sleep(5000)

    croc2 := Unit(5, 480, 435)

    Sleep(20000)

    vegeta1.Upgrade(2)
    vegeta2.Upgrade(2)

    Sleep(20000)

    bean1 := Unit(6, 620, 420)
    vegeta3.Upgrade(2)
    vegeta4.Upgrade(1)

    Sleep(12000)

    vegeta4.Upgrade(1)
    croc3 := Unit(5, 325, 435)
    sasuke1.Upgrade(1)

    Sleep(10000)

    sasuke2.Upgrade(1)
    sasuke3.Upgrade(1)

    loop 6 {
        wagon1.upgrade(1)
        sleep(50)
        wagon2.Upgrade(1)
        Sleep(50)
        wagon3.Upgrade(1)
        Sleep(10000)
    }

    bean2 := Unit(6, 645, 250, 5, 0)

	if macroLoopCount = 1 {
        if !ImageSearchLoop(namek10Path, 250, 50, 280, 67, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    } else {
        if !ImageSearchLoop(namek10AltPath, 250, 95, 280, 113, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    }

    igris1 := Unit(1, 405, 230)

    Sleep(80000)

    igris1.upgrade(12)
	return
}
PlanetNamekStandard() {
	sasuke1 := Unit(2, 700, 300, 10, 0)
	Sleep(30000)
	vegeta1 := Unit(3, 645, 300, 5, 0)
	Sleep(500)
	sasuke1.Sell()
	Sleep(10000)
	vegeta2 := Unit(3, 645, 385)
	Sleep(20000)
	vegeta3 := Unit(3, 585, 300)
	Sleep(5000)
	vegeta4 := Unit(3, 585, 385)

	if macroLoopCount = 1 {
        if !ImageSearchLoop(namek10Path, 250, 50, 280, 67, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    } else {
        if !ImageSearchLoop(namek10AltPath, 250, 95, 280, 113, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    }

	vegeta1.upgrade(2)
	vegeta2.Upgrade(2)
	Sleep(5000)
	vegeta3.Upgrade(2)
    Sleep(23000)
	vegeta4.Upgrade(2)

	sleep(40000)
	return
}

PlanetNamekAct0() {
    wagon1 := Unit(4, 760, 480, 5, 0)
    Sleep(20000)
    wagon2 := Unit(4, 670, 480, 5, 0)
    Sleep(20000)
    vegeta1 := Unit(3, 190, 168)
    Sleep(30000)
    vegeta2 := Unit(3, 405, 420)
    Sleep(30000)
    vegeta3 := Unit(3, 645, 385)
    Sleep(20000)
    vegeta4 := Unit(3, 585, 385)

    if macroLoopCount = 1 {
        if !ImageSearchLoop(namek10Path, 250, 50, 280, 67, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    } else {
        if !ImageSearchLoop(namek10AltPath, 250, 95, 280, 113, 1000, 120) {
            MsgBox("Could not detect wave 10", "Detect Wave Error", "T5")
            return false
        }
    }

    sasuke1 := Unit(2, 700, 300, 10, 0)

    vegeta1.Upgrade(2)
    vegeta2.Upgrade(2)
    vegeta3.Upgrade(2)
    vegeta4.Upgrade(7)

    Sleep(40000)
    vegeta4.Upgrade(5)
    return
}

; 700, 300, 10, 0 entry path area
; 645, 300, 5, 0
; 645, 385
; 585, 300
; 585, 385

; 570, 380 alligator spot
; 325 435

; 405, 230 center inline with player
; 405, 360
; 405, 420

; 340, 340 left and right of player
; 470, 340

; 355, 220 that vegeta spot

; 250, 190 inside top right bends
; 175, 130

; 760, 480 3 sprint wagons
; 670, 480
; 600, 480