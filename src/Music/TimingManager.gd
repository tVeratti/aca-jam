extends Node


const VOICE_DELAY:float = 30.0 # ms

# The purpose of this node is to keep all performing characters synced up.
# This will be based on one character (captain) and all others will listen.


var playback_time:float = 0.0

var delays:Array = []

func _ready():
	var current_delay:float = 0.0
	for id in Character.VoiceRanges.values():
		delays.append(current_delay)
		current_delay += 10.0


func register_voice(voice:int) -> float:
	delays[voice] += VOICE_DELAY
	return delays[voice]
