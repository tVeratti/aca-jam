extends Spatial

var character setget _set_character
var song:String setget _set_song
var is_captain:bool = false

onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	set_name(character.id)
	_load_song()
	
	BusManager.get_character_bus(character)
	audio_player.bus = character.id


func _process(delta):
	if is_captain:
		TimingManager.playback_time = audio_player.get_playback_position()


func sing(on:bool):
	if on:
		if not audio_player.playing: audio_player.play()
		if not is_captain:
			play_from_captain()
		audio_player.stream_paused = false
	else:
		audio_player.stream_paused = true


func play_from_captain():
	audio_player.seek(TimingManager.playback_time)


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
#		audio_player.pitch_scale = character.pitch_shift
