#Requires AutoHotkey v2.0 

/**
 * 
 * Original Creator : true_magician https://www.autohotkey.com/boards/viewtopic.php?t=123212
 * 
 * Modified by: yuh-source
 * 
 * @param {String} savepath file path to store the image, must include full directory and file extension/name
 * 
 */


imgSavePath := A_ScriptDir "\Images\UI\Webhook\RewardScreen.JPG"

CaptureRoblox(savePath := imgSavePath) {
    WinGetPos(&left, &top,,, "ahk_exe RobloxPlayerBeta.exe")
    width := 800
    height := 600
    left := left + 9
    top := top + 31
    hDstDevice := DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
	hBitmap := CreateDIBSection(hDstDevice, width, height)
	hBitmapObj := DllCall("SelectObject", "Ptr", hDstDevice, "Ptr", hBitmap, "Ptr")
	hSrcDevice := DllCall("GetDC", "Ptr", 0, "Ptr")
	DllCall("BitBlt", "Ptr", hDstDevice, "Int", 0, "Int", 0, "Int", width, "Int", height, "Ptr", hSrcDevice, "Int", left, "Int", top, "UInt", 0x40CC0020)
	DllCall("ReleaseDC", "Ptr", 0, "Ptr", hSrcDevice)

	DllCall("SelectObject", "Ptr", hDstDevice, "Ptr", hBitmapObj)
	DllCall("DeleteDC", "Ptr", hDstDevice)

    Convert(hBitmap, savePath)
    DllCall("DeleteObject", "Ptr", hBitmap)

}

Convert(savePathFr := "", savePathTo := imgSavePath, quality := 50) {
	SplitPath(savePathTo, , &sDirTo, &sExtTo, &sNameTo)

	hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll", "Ptr")
	if (!hGdiPlus)
		return Integer(savePathFr) ? SaveHBITMAPToFile(savePathFr, sDirTo (sDirTo == "" ? "" : "\") sNameTo ".bmp") : ""
	token := 0
	startupInput := Buffer(4 + A_PtrSize + 4 + 4, 0)
	NumPut("UInt", 1, startupInput)
	DllCall("gdiplus\GdiplusStartup", "UInt*", &token, "Ptr", startupInput, "Ptr", 0)

	pImage := 0

	if (savePathFr is Integer)
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", savePathFr, "Ptr", 0, "Ptr*", &pImage)
	else
		DllCall("gdiplus\GdipLoadImageFromFile", "WStr", savePathFr, "Ptr*", &pImage)

	nCount := 0, nSize := 0
	DllCall("gdiplus\GdipGetImageEncodersSize", "UInt*", &nCount, "UInt*", &nSize)
	encoders := Buffer(nSize, 0)
	DllCall("gdiplus\GdipGetImageEncoders", "UInt", nCount, "UInt", nSize, "Ptr", encoders)
	structSize := 48 + 7 * A_PtrSize
	offset := 32 + 3 * A_PtrSize
	pCodec := encoders.Ptr
	loop (nCount) {
		ext := StrGet(NumGet(offset + pCodec, "UPtr"), "UTF-16")
		if (InStr(ext, "*." sExtTo))
			break
		pCodec += structSize
	}

	pParam := 0
	if (InStr(".JPG.JPEG.JPE.JFIF", "." sExtTo) && quality != "" && pImage && pCodec < encoders.Ptr + nSize) {
		DllCall("gdiplus\GdipGetEncoderParameterListSize", "Ptr", pImage, "Ptr", pCodec, "UInt*", &nCount)
		params := Buffer(nCount, 0)
		structSize := 24 + A_PtrSize
		DllCall("gdiplus\GdipGetEncoderParameterList", "Ptr", pImage, "Ptr", pCodec, "UInt", nCount, "Ptr", params)
		loop (NumGet(params, 0, "UInt")) {
			if (NumGet(params, structSize * (A_Index - 1) + 16 + A_PtrSize, "UInt") == 1 && NumGet(params, structSize * (A_Index - 1) + 20 + A_PtrSize, "UInt") == 6) {
				pParam := params.Ptr + structSize * (A_Index - 1)
				NumPut("UInt", quality, NumGet(NumPut("UInt", 4, NumPut("UInt", 1, pParam + 0) + 16 + A_PtrSize), "UPtr"))
				break
			}
		}
	}

	if (pImage) {
		if (pCodec < encoders.Ptr + nSize) {
			DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pImage, "WStr", savePathTo, "Ptr", pCodec, "Ptr", pParam)
        }
	}
	DllCall("gdiplus\GdiplusShutdown", "UInt", token)
	DllCall("FreeLibrary", "Ptr", hGdiPlus)
}

CreateDIBSection(hDevice, width, height, bpp := 32, &pBits := 0) {
	bmInfo := Buffer(40, 0)
	NumPut("UInt", 40, "Int", width, "Int", height, "UShort", 1, "UShort", bpp, bmInfo, 0)
	return DllCall("gdi32\CreateDIBSection", "Ptr", hDevice, "Ptr", bmInfo, "UInt", 0, "Ptr*", &pBits, "Ptr", 0, "UInt", 0, "Ptr")
}

SaveHBITMAPToFile(hBitmap, savePath) {
	length := 64 + 5 * A_PtrSize
	obj := Buffer(length, 0)
	DllCall("GetObject", "Ptr", hBitmap, "Int", length, "Ptr", obj)
	saveFile := FileOpen(savePath, "w")
	saveFile.WriteShort(0x4D42)
	saveFile.WriteInt(54 + NumGet(obj, 36 + 2 * A_PtrSize, "UInt"))
	saveFile.WriteInt64(54 << 32)
	saveFile.RawWrite(obj.Ptr + 16 + 2 * A_PtrSize, 40)
	saveFile.RawWrite(NumGet(obj, 16 + A_PtrSize), NumGet(obj, 36 + 2 * A_PtrSize, "UInt"))
	saveFile.Close()
}