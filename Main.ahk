#Requires AutoHotkey v2.0 
#SingleInstance Force

CoordMode('Mouse', 'Window')
CoordMode('Pixel', 'Window')
SendMode('Input')

#Include lib\modules\Methods.ahk
#Include lib\modules\Gui.ahk
#Include lib\modules\Macro.ahk

MacroGui.Show()

MacroGui.addProcess("started")

MsgBox(Images.LevelElements.Paragon["drowsy"])