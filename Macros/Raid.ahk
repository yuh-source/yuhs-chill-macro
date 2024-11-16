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

    Sleep(60000)

    Sleep(14000)
    wagon1.Upgrade(4)
    wagon2.Upgrade(4)
    wagon3.Upgrade(4)

    Sleep(60000)

    vegeta2.Upgrade(5)
    vegeta3.Upgrade(5)
    vegeta4.Upgrade(5)

    Sleep(60000)

    vegeta2.Upgrade(3)
    vegeta3.Upgrade(3)
    vegeta4.Upgrade(6)

    return
}