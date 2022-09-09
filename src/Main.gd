extends Spatial

const GroupScene = preload("res://Group/Group.tscn")
const AuditionScene = preload("res://Events/Audition/Audition.tscn")

onready var scene:Spatial = $Scene



func _ready():
	EventManager.connect("select_event", self, "_on_select_event")
	EventManager.connect("end_event", self, "_on_end_event")
	
	to_audition()


func to_group() -> void:
	var group = GroupScene.instance()
	scene.add_child(group)


func to_audition() -> void:
	var audition = AuditionScene.instance()
	scene.add_child(audition)


func _on_select_event(event_type:int) -> void:
	match(event_type):
		Event.Types.AUDITION: to_audition()


func _on_end_event() -> void:
	to_group()
