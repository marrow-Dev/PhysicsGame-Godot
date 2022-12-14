extends Control


export var mod_manager : Resource

onready var mod_list = $Mod_List

var mod_location
var mods
var mods_scripts = []
var mods_resources = []
var gameLocation = OS.get_executable_path().get_base_dir()

func _ready():
	
	mods = mod_manager.get("mods")
	
	mod_location = str(gameLocation) + "/" + mod_manager.get("manager_name") + "/"
	
	load_mods(mod_location) # running the load mods function


func load_mods(path):
	var modDirectory = Directory.new() # making a new dir variable
	if modDirectory.open(path) == OK:
		modDirectory.list_dir_begin()
		print("Started M O D scan")
			
		var currentFile = modDirectory.get_next()
		while currentFile != "": # if the currentFile isn't blank
			if currentFile.begins_with("."): # if the file starts with .
				pass
				
			elif modDirectory.current_is_dir(): # if it's a directory
				
				print("Found directory: " + currentFile)
				
				var newModDirectory = Directory.new()
				
				if newModDirectory.open(path + currentFile) == OK:
					
					newModDirectory.list_dir_begin()
					
					var currentChildFile = newModDirectory.get_next()
					var fileAmount = 0
					var files = []
					while currentChildFile != "":
						if currentChildFile.begins_with("."):
							pass
						
						elif newModDirectory.current_is_dir():
							print("Found folder: " + currentChildFile)
							
						elif not newModDirectory.current_is_dir():
							
							print("Found file: " + currentChildFile)
							fileAmount += 1
							files.append(currentChildFile)
							
						
						currentChildFile = newModDirectory.get_next()
					newModDirectory.list_dir_end()
					if fileAmount == 4:
						for file in files:
							print(file)
							if file.ends_with(".tres"):
								mods_resources.append(str(path + currentFile + "/" + file))
								var mod_resource = load(str(path + currentFile + "/" + file))
								var mod_name = mod_resource.get("mod_name")
								mod_list.add_item(mod_name)
							
							if file.ends_with(".tscn") and file.begins_with("Map-"):
								Globals.customLevels.append(str(path + currentFile + "/" + file))
								print("Found map: " + file)
							
							elif file.ends_with(".tscn") and file.begins_with("Item-"):
								Globals.customItems.append(load(path + currentFile + "/" + file))
								print("Found item: " + file)
					
			currentFile = modDirectory.get_next()
			
		modDirectory.list_dir_end()
	
		var counted = 0
		
		for mod in mods:
			mod.script = mods_scripts[counted]
			print("Loaded script")
			counted += 1
		
		print(Globals.customLevels)
		
	else:
		print("Failed to load mods!")
