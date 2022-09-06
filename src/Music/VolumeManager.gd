extends Node


var note_timer:Timer

func _ready():
	note_timer = Music.create_note_timer()
	add_child(note_timer)
	note_timer.connect("timeout", self, "_on_note_timeout")


func _on_note_timeout():
	pass
