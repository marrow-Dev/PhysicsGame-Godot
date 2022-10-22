extends Control

# All button variables
onready var quitButton = $buttonContainers/quitButton
onready var sandboxButton = $buttonContainers/sandboxButton
onready var settingsButton = $buttonContainers/settingsButton

onready var settingsMenu = $buttonContainers/Settings
onready var settingsBackButton = $buttonContainers/Settings/itemContainer/backButton

onready var seperateUIObjects = [ # put everything here that you want to be hidden when the settings menu is shown
	$RichTextLabel,
	$buttonContainers/quitButton,
	$buttonContainers/sandboxButton,
	$buttonContainers/settingsButton
]


# Called when the node enters the scene tree for the first time.
func _ready():
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
