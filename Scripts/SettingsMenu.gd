extends Control

var multiSpawn = Globals.multiSpawn

onready var changeSpawnMode = $changeSpawnMode
onready var backButton = $backButton

### TEXTURES ###
onready var semiSpawnTex = load("res://Textures/spawnSemiButton.png")
onready var autoSpawnText = load("res://Textures/spawnAutoButton.png")


func _ready():
	
	self.visible = false
	
	if Globals.multiSpawn:
		changeSpawnMode.set_normal_texture(autoSpawnText)
	else:
		changeSpawnMode.set_normal_texture(semiSpawnTex)


func _physics_process(delta):
	if changeSpawnMode.is_hovered() and Input.is_action_just_pressed("shoot"):
		if Globals.multiSpawn:
			changeSpawnMode.set_normal_texture(semiSpawnTex)
			Globals.multiSpawn = false
		else:
			changeSpawnMode.set_normal_texture(autoSpawnText)
			Globals.multiSpawn = true
	elif backButton.is_hovered() and Input.is_action_just_pressed("shoot"):
		self.visible = false
