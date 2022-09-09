extends Node


class_name Songs

const WAV_PATH:String = "res://Music/Songs/%s/%s - %s.wav"

const SINCE_U_BEEN_GONE = "Since u been gone"


static func get_wav_by_voice(song:String, voice:String) -> Resource:
	var voice_lower = voice.to_lower()
	var file_name:String = WAV_PATH % [song, song, voice_lower]
	return load(file_name)
