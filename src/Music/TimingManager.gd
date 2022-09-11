extends Node


const VOICE_DELAY:float = 30.0 # ms

# The purpose of this node is to keep all performing characters synced up.


var playback_time:float setget , _get_playback
var song:String setget _set_song

var delays:Array = []

var song_timer:Timer


func _ready():
	song_timer = Timer.new()
	song_timer.one_shot = false
	song_timer.autostart = false
	add_child(song_timer)
	
	var current_delay:float = 0.0
	for id in Character.VoiceRanges.values():
		delays.append(current_delay)
		current_delay += 10.0


func start():
	song_timer.start()


func stop():
	song_timer.stop()


func register_voice(voice:int) -> float:
	delays[voice] += VOICE_DELAY
	return delays[voice]


func _get_playback() -> float:
	return song_timer.wait_time - song_timer.time_left


func _set_song(value:String):
	song = value
	
	var stream:AudioStream = Songs.get_wav_by_voice(value, "soprano")
	song_timer.wait_time = stream.get_length() / 1000.0
