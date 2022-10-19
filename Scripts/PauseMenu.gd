extends Control


var isPaused = false
onready var ResumeButton = $TextureButton
onready var QuitButton = $QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	isPaused = false
	self.visible = false


func _process(delta):
	
	if Input.is_action_just_pressed("PauseMenu"):
		if not isPaused:
			isPaused = true
			self.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if ResumeButton.is_pressed():
		closePauseMenu()
	if QuitButton.is_pressed():
		closeGame()

func closePauseMenu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	isPaused = false
	self.visible = false

func closeGame():
	get_tree().change_scene("res://Menus/MainMenu.tscn")
