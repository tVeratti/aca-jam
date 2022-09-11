extends Spatial

var character setget _set_character
var song:String setget _set_song

onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	set_name(character.id)
	_load_song()
	
	BusManager.get_character_bus(character)
	audio_player.bus = character.id


func sing(on:bool):
	if on:
		if not audio_player.playing: audio_player.play()
		audio_player.seek(TimingManager.playback_time)
		audio_player.stream_paused = false
	else:
		audio_player.stream_paused = true


func _set_song(value):
	song = value
	_load_song()


func _set_character(value): 
	character = value
	_load_song()


func _load_song():
	if character != null and is_instance_valid(audio_player):
		var audio = Songs.get_wav_by_voice(song, character.voice_label)
		audio_player.stream = audio
