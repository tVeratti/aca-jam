extends Control

const TraitSummaryScene = preload("res://Character/Traits/TraitSummary.tscn")


var character setget _set_character

onready var name_label:Label = get_node("%Name")
onready var voice_label:Label = get_node("%Voice")
onready var level_label:Label = get_node("%Level")
onready var traits_box:HBoxContainer = get_node("%Traits")


func _ready():
	render_character()


func render_character() -> void:
	if is_instance_valid(name_label) and character != null:
		name_label.text = character.full_name
		voice_label.text = character.voice_label
		level_label.text = "Lv. %s" % character.level
		
		for child in traits_box.get_children(): child.queue_free()
		for trait in character.traits:
			var trait_summary = TraitSummaryScene.instance()
			trait_summary.trait = trait
			traits_box.add_child(trait_summary)


func _set_character(value) -> void:
	character = value
	render_character()
