extends Spatial

onready var playerHand = $Player/Head/Camera/HoldPosition
var selectedObject = 0

# loading the scenes to spawn in - NOTE: These are ones that are added manually
var bottleObject = load("res://assets/bottle.tscn")
var tableObject = load("res://assets/Table.tscn")

var location = OS.get_executable_path().get_base_dir()

var spawnableObjects = []

func _ready():
	
	# adding the base assets to the spawnableObjects array
	spawnableObjects = [
		bottleObject,
		tableObject
	]
	
	var files = []
	var dir = Directory.new()
	dir.open(str(location)+"/CustomItems")
	print(dir)
	
	for n in range(10):
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			spawnObject(0)
	dir.list_dir_end()

func _physics_process(delta):
	
	if Input.is_action_just_pressed("object0"):
		selectedObject = 0
		print("Now spawning bottle")
	elif Input.is_action_just_pressed("object1"):
		selectedObject = 1
		print("Now spawning table")
	
	if Input.is_action_just_pressed("spawnBottle"):
		spawnObject(selectedObject)

func spawnObject(object):

	# creating the instances
	var spawnableInstance = spawnableObjects[object].instance()

	add_child(spawnableInstance)
	spawnableInstance.global_transform.origin = playerHand.global_transform.origin
