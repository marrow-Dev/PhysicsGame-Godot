extends Node

###### Game options ######
var modSupport = false
var multiSpawn = false
var isPaused = false

###### Gun Options ######
var gunFireMode = 0
var gunFireTypes = [
	"Semi-Auto",
	"Full-Auto"
]
var maxFireMode = 1


### Menu Functions ###

func showMenu(menu, parentMenu): # for showing menus
	menu.visible = true
	for obj in parentMenu:
		obj.visible = false

func hideMenu(menu, parentMenu): # for hiding menus
	menu.visible = false
	for obj in parentMenu:
		obj.visible = true
