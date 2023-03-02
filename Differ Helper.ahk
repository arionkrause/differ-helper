#persistent
#noEnv
#singleInstance force
#noTrayIcon
setWorkingDir %A_ScriptDir%

iniRead diffToolCommand, Differ Helper.ini, app, diffToolCommand

menu tray, useErrorLevel
menu tray, icon, Differ Helper.ico
menu tray, icon
menu tray, useErrorLevel, Off
menu tray, noIcon

gui add, text, x20 y20, Path 1:
gui add, edit, x20 y40 w540 vpath1
gui add, button, x570 y38 gbrowsePath vbrowsePath1, Browse...

gui add, text, x20 y90 vpath2Text, Path 2:
gui add, edit, x20 y110 w540 vpath2
gui add, button, x570 y108 gbrowsePath vbrowsePath2, Browse...

gui add, button, x285 y160 w80 h30 gcompare, Compare
gui +lastFound
gui show, w640 h200, Differ Helper
return


browsePath:
	fileSelectFile path

	if (path != "") {
		if (A_GuiControl == "browsePath1") {
			guiControl, , path1, %path%
		} else {
			guiControl, , path2, %path%
		}
	}
	return


compare:
	if (diffToolCommand == "ERROR") {
		msgBox Catastrophic failure!`ndiffToolCommand is empty
		return
	}

	guiControlGet path1
	guiControlGet path2

	if (path1 == "" || path2 == "") {
		msgBox You must select two paths to compare!
		return
	}

	run %diffToolCommand% "%path1%" "%path2%"
	return


guiDropFiles(guiHandle, pathArray, controlHandle, x, y) {
	for i, path in pathArray {
		pathsAmount++
	}

	if (pathsAmount == 1) {
		path := pathArray[1]

		guiControlGet path2Text, pos

		varSetCapacity(rect, 16, 0)
		dllCall("GetClientRect", uint, MyGuiHWND := WinExist(), uint, &rect)
		clientHeight := numGet(rect, 12, "int")
		winGetPos, , , windowId, windowHeight

		if (A_GuiY < (windowHeight - clientHeight + path2TextY)) {
			guiControl, , path1, %path%
		} else {
			guiControl, , path2, %path%
		}
	} else {
		guiControl, , path1, % pathArray[1]
		guiControl, , path2, % pathArray[2]
	}
}


GuiClose:
exitApp:
	exitApp
	return