extends Spatial

onready var playerHand = $Player/Head/Camera/HoldPosition
var selectedObject = 0

# loading the scenes to spawn in
var bottleObject = load("res://assets/bottle.tscn")
var tableObject = load("res://assets/Table.tscn")

var spawnableObjects = [
	bottleObject,
	tableObject
]

func _ready():
	pass

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
