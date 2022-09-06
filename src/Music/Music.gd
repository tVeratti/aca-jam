extends Node


class_name Music


const NOTE_DURATION:float = 0.3
const NOTE_TRANSITION:float = 0.1


static func create_note_timer() -> Timer:
	var note_timer:Timer = Timer.new()
	note_timer.wait_time = NOTE_DURATION
	note_timer.one_shot = false
	note_timer.autostart = true
	return note_timer
