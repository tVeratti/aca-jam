extends Control


var character setget _set_character

onready var name_label:Label = get_node("%Name")
onready var voice_label:Label = get_node("%Voice")
onready var level_label:Label = get_node("%Level")


func _ready():
	render_character()


func render_character() -> void:
	if is_instance_valid(name_label) and character != null:
		name_label.text = character.full_name
		voice_label.text = character.voice_label
		level_label.text = "Lv. %s" % character.level


func _set_character(value) -> void:
	character = value
	render_character()
