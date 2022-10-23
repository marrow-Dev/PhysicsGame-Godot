extends Spatial

var modSupport = Globals.modSupport
var multiSpawn = Globals.multiSpawn
onready var playerHand = $Player/Head/Camera/HoldPosition
onready var objectLabel = $currentItem
var selectedObject = 0
var objectCount = 4

# loading the scenes to spawn in - NOTE: These are ones that are added manually
var bottleObject = load("res://Spawnables/Bottle.tscn")
var tableObject = load("res://Spawnables/Table.tscn")
var crateObject = load("res://Spawnables/WoodenCrate.tscn")
var targetObject = load("res://Spawnables/Target.tscn")

# for built-in or modpack assets here's the format:
# var [object name]Object = load("[res:// path for the .tscn file]")


var gameLocation = OS.get_executable_path().get_base_dir()
var dir = Directory.new()
var gameDirectory = Directory.new()
var scriptsDir = Directory.new()


var customScripts = []
var spawnableObjects = []
var objectNames = []




func _ready():
	gameDirectory.open(gameLocation)
	
	objectCount -= 1
	
	# adding the base assets to the spawnableObjects array
	spawnableObjects = [
		bottleObject,
		tableObject,
		crateObject,
		targetObject
	]
	
	objectNames = [
		"Bottle",
		"Table",
		"Crate",
		"Target"
	]
	
	if modSupport and gameDirectory.dir_exists("CustomScripts"):
		var scriptsLoaded = []
		scriptsDir.open(str(gameDirectory)+"/CustomScripts")
		scriptsDir.list_dir_begin()
		
		for scriptAmount in range(1000):
			var currentScript = scriptsDir.get_next()
			
			if currentScript == "":
				break
			
			elif not currentScript.begins_with("."):
				if currentScript.ends_with(".gd"):
					var newCustomScript = str(gameLocation)+"/CustomScripts/"+str(currentScript)
					
					print("Loaded new script: " + newCustomScript.replace(".gd", ""))
					customScripts.append(newCustomScript)
		scriptsDir.list_dir_end()
	
	if modSupport and gameDirectory.dir_exists("CustomItems"):
		var files = []
		
		dir.open(str(gameLocation)+"/CustomItems")
		dir.list_dir_begin()
			
		for n in range(1000):
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				var newObject = load(str(gameLocation)+"/CustomItems/"+str(file))
				var objectName = file.replace(".tscn", "")
				if dir.current_is_dir():
					var childDirectory = Directory.new()
					childDirectory.open(str(gameLocation)+"/CustomItems/"+str(file))
					childDirectory.list_dir_begin()
					for x in range(1000):
						var childFile = childDirectory.get_next()
						if childFile == "":
							break
						elif not childFile.begins_with("."):
							print(str(childFile))
							if childFile.ends_with(".tscn"):
								var childObject = load(str(gameLocation)+"/CustomItems/"+str(file)+"/"+str(childFile)) # loading the custom item
								spawnableObjects.append(childObject) # adding the custom item to the game
								var childName = childFile.replace(".tscn", "")
								objectNames.append(childName)
								objectCount += 1
								print(childName)
				if file.ends_with(".tscn"):
					objectNames.append(objectName)
					objectCount += 1
					spawnableObjects.append(newObject)
		dir.list_dir_end()
	
	print("Current spawnable object count : " + str(objectCount + 1))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("itemSelectionUp"):
		if selectedObject < objectCount:
			selectedObject += 1
			objectLabel.text = objectNames[selectedObject]
			print("Object switched up")
	elif Input.is_action_just_pressed("itemSelectionDown"):
		if selectedObject > 0:
			selectedObject -= 1
			objectLabel.text = objectNames[selectedObject]
			print("Object switched down")
	
	if Globals.multiSpawn:
		if Input.is_action_pressed("spawnBottle"):
			spawnObject(selectedObject)
	elif not Globals.multiSpawn:
		if Input.is_action_just_pressed("spawnBottle"):
			spawnObject(selectedObject)

func spawnObject(object):

	# creating the instances
	var spawnableInstance = spawnableObjects[object].instance()

	add_child(spawnableInstance)
	spawnableInstance.global_transform.origin = playerHand.global_transform.origin
