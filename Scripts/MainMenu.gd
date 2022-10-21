extends Control

# All button variables
onready var quitButton = $quitButton
onready var sandboxButton = $sandboxButton
onready var settingsButton = $settingsButton


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
		self.visible = false
		$Settings.visible = true
	
	# Quit game button
	if quitButton.is_pressed():
		get_tree().quit()
