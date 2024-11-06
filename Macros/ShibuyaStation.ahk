#Requires AutoHotkey v2.0

ShibuyaStationAct7() {
    Sleep(500)
    vegeta1 := Unit(3, 190, 340, 0, -15)
    vegeta2 := Unit(3, 230, 340, 0, -15)
    Sleep(5700)
    vegeta3 := Unit(3, 300, 340, -5, -20)
    Sleep(5000)
    vegeta4 := Unit(3, 220, 380, 0, -20)

    Sleep(15000)
    
    vegeta1.Upgrade(2)
    
    Sleep(20000)

    vegeta2.Upgrade(2)

    Sleep(20000)

    vegeta3.Upgrade(2)
    
    Sleep(20000)

    vegeta4.Upgrade(2)

    Sleep(30000)

    vegeta1.Upgrade(3)

    Sleep(40000)

    vegeta2.Upgrade(3)

    loop 2 {
        Sleep(30000)

        vegeta3.Upgrade(2)
    }

    loop 6 {
        Sleep(30000)

        vegeta4.Upgrade(2)
    }
}