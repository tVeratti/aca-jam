extends Spatial

const PortraitScene = preload("res://Character/Portrait.tscn")

onready var money_label:Label = get_node("%Money")
onready var characters_box = get_node("%Characters")


func _ready():
	render_characters()
	render_resources()
	
	GroupManager.connect("characters_changed", self, "_on_characters_changed")
	GroupManager.connect("resources_changed", self, "_on_resources_changed")
	EventManager.connect("select_event", self, "_on_select_event")


func render_characters() -> void:
	var character_ids:Array = []
	for character in GroupManager.characters:
		character_ids.append(character.id)
		if characters_box.has_node(character.id):
			characters_box.get_node(character.id).character = character
		else:
			var portrait = PortraitScene.instance()
			portrait.character = character
			characters_box.add_child(portrait)
			portrait.set_name(character.id)
	
	for node in characters_box.get_children():
		if not character_ids.has(node.character.id):
			node.queue_free()


func render_resources():
	money_label.text = "$%s" % GroupManager.money


func _on_characters_changed():
	render_characters()


func _on_resources_changed():
	render_resources()


func _on_select_event(_type):
	queue_free()


func _on_Audition_pressed():
	EventManager.select_event(Event.Types.AUDITION)


func _on_Practice_pressed():
	EventManager.select_event(Event.Types.PRACTICE)


func _on_Perform_pressed():
	EventManager.select_event(Event.Types.SHOW)
