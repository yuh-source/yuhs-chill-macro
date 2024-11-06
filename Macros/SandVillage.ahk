#Requires AutoHotkey v2.0

SandVillageStandard() {
    wagon1 := Unit(4, 353, 67)
    Sleep(35000)
    wagon2 := Unit(4, 305, 98)
    Sleep(10000)
    vegeta1 := Unit(3, 93, 427, -7, -1)
    Sleep(30000)
    vegeta2 := Unit(3, 30, 122, -1, -2)
    Sleep(30000)
    vegeta3 := Unit(3, 70, 152, -5, -2)
    vegeta4 := Unit(3, 110, 118, -5, -3)
    
    wagon3 := Unit(4, 190, 565)
    Sleep(100000)

    vegeta2.Upgrade(2)
    vegeta3.Upgrade(2)
    vegeta4.Upgrade(5)

    Sleep(60000)
    vegeta4.Upgrade(3)
    return
}

SandVillage0() {
    wagon1 := Unit(4, 353, 67)
    Sleep(35000)
    wagon2 := Unit(4, 305, 98)
    Sleep(10000)
    vegeta1 := Unit(3, 93, 427, -7, -1)
    Sleep(30000)
    vegeta2 := Unit(3, 30, 122, -1, -2)
    Sleep(30000)
    vegeta3 := Unit(3, 70, 152, -5, -2)
    vegeta4 := Unit(3, 110, 118, -5, -3)
    
    wagon3 := Unit(4, 190, 565)
    Sleep(100000)

    vegeta2.Upgrade(2)
    vegeta3.Upgrade(2)
    vegeta4.Upgrade(5)

    Sleep(60000)
    vegeta4.Upgrade(3)
    return
}