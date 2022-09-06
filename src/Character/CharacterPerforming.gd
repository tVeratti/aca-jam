extends Character


onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	audio_player.pitch_scale = pitch_shift
