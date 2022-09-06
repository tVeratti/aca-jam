extends Node



var soprano_pitch_map:Resource
var pitch_index:int = 0

var soprano_pitch:AudioEffect
var note_timer:Timer


func _ready():
	soprano_pitch = AudioServer.get_bus_effect(1, 0)
	
	note_timer = Music.create_note_timer()
	add_child(note_timer)
	note_timer.connect("timeout", self, "_on_note_timeout")


func next_pitch():
	var pitches = soprano_pitch_map.pitches
	if pitches.size() <= pitch_index: pitch_index = 0
	
	var new_pitch:float = pitches[pitch_index]
	tween_pitch(soprano_pitch, new_pitch)
	pitch_index += 1


func tween_pitch(pitch_effect:AudioEffect, new_pitch:float):
	var pitch_tween = create_tween()
	pitch_tween.tween_property(pitch_effect, "pitch_scale", new_pitch, Music.NOTE_TRANSITION)


func _on_note_timeout():
	next_pitch()
