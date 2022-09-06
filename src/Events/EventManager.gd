extends Node


# Manage the game event timeline

signal select_event(event)
signal end_event()


var current_event_type:int = Event.Types.AUDITION
var _event_imdex:int = 0


func select_event(event_type:int) -> void:
	current_event_type = event_type
	_event_imdex += 1
	emit_signal("select_event", current_event_type)


func end_event() -> void:
	emit_signal("end_event")
