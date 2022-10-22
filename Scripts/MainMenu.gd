extends Control

var currentMapSelected = 0
var mapCount = -1
var levelsDir = Directory.new()
var gameDirectory = Directory.new()

onready var modSupport = Globals.modSupport
onready var gameLocation = OS.get_executable_path().get_base_dir()

# All button variables
onready var quitButton = $buttonContainers/quitButton
onready var sandboxButton = $buttonContainers/sandboxButton
onready var settingsButton = $buttonContainers/settingsButton
onready var switchingButton = $buttonContainers/switchingButton
onready var playCustomLevelButton = $buttonContainers/playLevelButton

onready var settingsMenu = $buttonContainers/Settings
onready var settingsBackButton = $buttonContainers/Settings/itemContainer/backButton

onready var seperateUIObjects = [ # put everything here that you want to be hidden when the settings menu is shown
	$logoThingy,
	quitButton,
	sandboxButton,
	settingsButton,
	playCustomLevelButton
]

var customLevels = []
var customLevelNames = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	gameDirectory.open(str(gameLocation))
	
	if not modSupport:
		$buttonContainers/switchingButton/Label.text = "No mod support!"
	
	if modSupport and gameDirectory.dir_exists("CustomMaps"):
		var levelsLoaded = []
		levelsDir.open(str(gameLocation)+"/CustomMaps") # telling the game where to look for maps
		levelsDir.list_dir_begin() # beginning going through the files
		
		for mapAmount in range(1000): # will look at a max of 1000 maps
			var currentMap = levelsDir.get_next()
			
			if currentMap == "": # making sure the game isn't looking for an empty file
				break
			
			elif not currentMap.begins_with("."): # if it hasn't reached the end of the customMaps list
				var newCustomMap = str(gameLocation) + "/CustomMaps/" + str(currentMap)
				var newCustomMapName = str(currentMap).replace(".tscn", "")
				print("Loaded new map: " + newCustomMapName)
				customLevelNames.append(newCustomMapName)
				customLevels.append(newCustomMap)
				mapCount += 1
		levelsDir.list_dir_end()
		$buttonContainers/switchingButton/Label.text = customLevelNames[currentMapSelected]
	else:
		$buttonContainers/switchingButton/Label.text = "No Map Folder Found!"
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sandbox level button
	if sandboxButton.is_pressed():
		self.visible = false
		get_tree().change_scene("res://Levels/SandboxLevel.tscn")
	
	# Settings menu button
	if settingsButton.is_pressed():
		Globals.showMenu($buttonContainers/Settings, seperateUIObjects)
	
	# Quit game button
	if quitButton.is_pressed():
		get_tree().quit()
	
	if settingsBackButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		Globals.hideMenu($buttonContainers/Settings, seperateUIObjects)
	
	if switchingButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		if modSupport and gameDirectory.dir_exists("CustomMaps"):
			if currentMapSelected < mapCount:
				print("new map")
				$buttonContainers/switchingButton/Label.text = customLevelNames[currentMapSelected]
				currentMapSelected += 1
			else:
				print("reset map")
				$buttonContainers/switchingButton/Label.text = customLevelNames[currentMapSelected]
				currentMapSelected = 0
	
	if playCustomLevelButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		if modSupport:
			get_tree().change_scene(customLevels[currentMapSelected])
