extends Node


const RESOURCE_PATH = "res://Character/Traits/Resources"

const FORGETFUL = "forgetful"
const QUICK_LEARNER = "quick_learner"

var traits:Array = []


func _ready():
	load_traits()


func load_traits() -> void:
	var dir = Directory.new()
	dir.open(RESOURCE_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while(file_name != ""): 
		if dir.current_is_dir(): pass
		else:
			var trait = load(RESOURCE_PATH + "/" + file_name)
			traits.append(trait)
			
		file_name = dir.get_next()


func get_trait(id:String) -> Resource:
	var id_lower:String = id.to_lower()
	for trait in traits:
		if trait.id.to_lower() == id_lower:
			return trait.duplicate()
	
	return null


func get_random_trait() -> Resource:
	return Random.get_random_item(traits).duplicate()
