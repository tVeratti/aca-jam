extends Control


var trait setget _set_trait

onready var name_label:Label = get_node("%Name")
onready var description_label:Label = get_node("%Description")


func _ready():
	render_trait()


func render_trait():
	if trait != null and is_instance_valid(name_label):
		name_label.text = trait.title
		description_label.text = trait.description


func _set_trait(value):
	trait = value
	render_trait()
