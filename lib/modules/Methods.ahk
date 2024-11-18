#Requires AutoHotkey v2.0 

class GuiMethods extends Gui {
    static Close(exit := true) {
        TTaskMethods.Ctrl(, true)
        if exit {
            if WinExist("ahk_exe RobloxPlayerBeta.exe") {
                WinMove(7, 21, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
            }
            return ExitApp()
        }
        reload()
        Sleep(500)
    }

    static ChangeDDl(ctrl, arrays, toggle := 0) {
        cIndex := ctrl.Value
        ctrl.Delete(), ctrl.Add(arrays[toggle + 1])
        (cIndex > arrays[toggle + 1].Length) ? ctrl.Choose(1) : ctrl.Choose(cIndex)
    }

    AddTitleGroupBox(textColour, x, y, boxTitle, w := 420, h := 60, fontSize := 10) {
        this.SetFont("s" fontSize)
        this.AddGroupBox("c" textColour " x" x " y" y " w" w " h" h, boxTitle)
        this.SetFont("s8")
    }
}

class FileMethods {
    static Read(filePath) {
        return FileExist(filePath) ? FileRead(filePath) : ""
    }

    static Write(filePath, text) {
        FileDelete(filePath)
        FileAppend(text, filePath)
    }
}

class StrMethods {
    static Contains(str, substr) {
        return InStr(str, substr) ? true : false
    }

    static Matches(str, regex) {
        return RegExMatch(str, regex) ? true : false
    }

    static InArr(str, arr) {
        for key, value in arr
            if (value == str)
                return true
        return false
    }
}

class TTaskMethods {
    static Ctrl(ttPath := "", kill := false) {
        static PID := ""
        if !kill {
            try {
                RunWait(ttPath,,, &PID)
                return true
            } catch {
                return false
            }
        }
        if PID != "" {
            ProcessClose(PID)
        }
    }
}

class Images {
    static lobby := {
        play: "*75 " A_ScriptDir "\lib\resources\Lobby\Play Button.png",
        stages: "*100 " A_ScriptDir "\lib\resources\Lobby\Stages.png",
        notEnoughItems: "*100 " A_ScriptDir "\lib\resources\Lobby\Not Enough Items.png",
        
        challenges: {
            PlanetNamek: "*100 " A_ScriptDir "\lib\resources\Lobby\PlanetNamek Challenge Banner.png",
            SandVillage: "*100 " A_ScriptDir "\lib\resources\Lobby\SandVillage Challenge Banner.png",
            DoubleDungeon: "*100 " A_ScriptDir "\lib\resources\Lobby\DoubleDungeon Challenge Banner.png",
            ShibuyaStation: "*100 " A_ScriptDir "\lib\resources\Lobby\ShibuyaStation Challenge Banner.png"
        }
    }

    static level := {
        voteStart: "*75 " A_ScriptDir "\lib\resources\Level\Vote Start.png",
        returnToLobby: "*100 " A_ScriptDir "\lib\resources\Level\Return To Lobby Button.png",
        gemsReward: "*75 " A_ScriptDir "\lib\resources\Level\Gems Reward.png",
        stageInfo: "*50 " A_ScriptDir "\lib\resources\Level\Stage Info.png",
        settings: "*160 " A_ScriptDir "\lib\resources\Level\Settings Icon.png",

        paragon: this.InitParagonMap()
    }

    static InitParagonMap() {
        mp := Map()
        Loop MacroGui.modArray.Length {
            mp[MacroGui.modArray[A_Index]] := "*25 " A_ScriptDir "\lib\resources\Level\Paragon\" MacroGui.modArray[A_Index] ".png"
        }
        return mp
    }
}

class Utils {
    static wClick(button, x, y, clickDelay := 0) {
        MouseMove(x, y)
        MouseMove(1, 0, , "R")
        Sleep(clickDelay)
        MouseClick("Left", -1, 0, , , , "R")
        Sleep(50)
    }

    static DllSleep(lPeriod) {
        if (hTimer := DllCall("CreateWaitableTimerExW", "ptr", 0, "ptr", 0, "uint", 3, "uint", 0x1F0003, "uptr"))
            && DllCall("SetWaitableTimer", "uptr", hTimer, "uint64*", lPeriod * -10000, "int", 0, "ptr", 0, "ptr", 0, "int", 0)
            DllCall("WaitForSingleObject", "uptr", hTimer, "UInt", 0xFFFFFFFF), DllCall('CloseHandle', "uptr", hTimer)
    }

    static ImageSearchLoop(imagePath, X1, Y1, X2, Y2, searchDelay := 1000, maxRetryCount := 15, &FoundX := 0, &FoundY := 0) {
        loop maxRetryCount + 1 {
            if !Roblox.Focus()
                return false
                
            if ImageSearch(&FoundX, &FoundY, X1, Y1, X2, Y2, imagePath)
                return true
                
            Sleep(searchDelay)
        }
        return false
    }
}

class Roblox {
    static Focus() {
        loop 15 {
            if WinExist("ahk_exe RobloxPlayerBeta.exe") {
                WinActivate("ahk_exe RobloxPlayerBeta.exe")
                return true
            }
            Sleep(1000)
        }
        MacroGui.addProcess("Cant Find Roblox")
        return false
    }

    static Join() {
        psLink := fileMethods.Read(A_ScriptDir "\Settings\PSLink.txt")

        if MacroGui.ui["privToggle"].Value {
            if psLink != "" {
                MacroGui.addProcess("Joining Set Private Server")
                return Run(psLink)
            } else {
                MacroGui.addProcess("Invalid Private Server")
                return
            }
        }
    }

    static Attach() {
        MacroGui.addProcess("Cant Find Roblox")
        this.Join()
        WinWait("ahk_exe RobloxPlayerBeta.exe")
    
        MacroGui.addProcess("Attatching to Roblox")
        this.Focus()
        WinRestore("ahk_exe RobloxPlayerBeta.exe")
    
        this.mv()
    }

    static mv() {
        WinGetPos(&X, &Y,,, MacroGui.ui)
        WinMove(X - 8, Y + 5, 800, 600, "ahk_exe RobloxPlayerBeta.exe")
    }
}

class Capture {
    static imgSavePath := A_ScriptDir "\lib\resources\level\rewards.jpg"
    static modSavePath := A_ScriptDir "\lib\resources\Level\Paragon\modifiers.png"

    static ToWebHook() {
        this.Roblox()

        thumbnailimg := A_ScriptDir "\lib\resources\UI\him.jpg"
        webhook := Discord.Webhook(FileMethods.Read(A_ScriptDir "\Settings\DiscordWebhook.txt"))
        image := AttachmentBuilder(this.imgSavePath)
        thumbnail := AttachmentBuilder(thumbnailimg)

        embed := EmbedBuilder()
        embed.setTitle("yuhs-chill-macro")
        embed.setDescription("mfw webhook")
        embed.setURL("https://github.com/yuh-source/yuhs-chill-macro")
        embed.setColor(0xFFFFFF)
        embed.addFields([
        {
        name:"Macro Status",
        value: MacroGui.ui["displayLoops"].Text "`n" MacroGui.ui["rph"].Text "`n" MacroGui.ui["timeElapsed"].Text,
        inline: true
        },
        {
        name: "Challenge Info",
        value: MacroGui.ui["displayChals"].Text,
        inline: true
        },
        ])
        embed.setFooter({text:"yuh"})
        embed.setThumbnail({url:thumbnail.attachmentName})
        embed.setImage({url:image.attachmentName || this.imgSavePath})

        webhook.send({
        embeds: [embed],
        files: [image]
        })
        MacroGui.addProcess("Sending Capture To Webhook")
    }

    static Roblox() {
        WinGetPos(&X, &Y, &W, &H, "ahk_exe RobloxPlayerBeta.exe")

        wgcp := wincapture.WGC()
        box := Buffer(16, 0)
        NumPut("uint", X + 8, "uint", Y + 31, "uint", X + 811, "uint", Y + 631, box)
        bmBuf := wgcp.capture(box)
        bmBuf.save(this.imgSavePath)
    }

    static Paragon() {
        WinGetPos(&X, &Y, &W, &H, "ahk_exe RobloxPlayerBeta.exe")

        wgcp := wincapture.WGC()
        box := Buffer(16, 0)
        NumPut("uint", X + 220 , "uint", Y + 283, "uint", X + 220 + 380, "uint", Y + 285 + 15, box)

        bmBuf := wgcp.capture(box)

        param := RapidOcr.OcrParam()
        ocr := RapidOcr({ models: A_ScriptDir '\lib\modules\rapidocr\models' })

        ocrout := ocr.ocr_from_bitmapdata(bmBuf.cvtGray(1).threshold(1, 23).info)
        MsgBox(ocrout)
    }
}
