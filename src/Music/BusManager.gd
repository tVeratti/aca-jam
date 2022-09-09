extends Node

const DEFAULT_VOLUME:float = -5.0
const FOCUS_VOLUME:float = 0.0
const QUIET_VOLUME:float = -20.0


func get_character_bus(character) -> int:
	# Create/Get audio bus for this character
	if AudioServer.get_bus_index(character.id) == -1:
		var bus_index = AudioServer.bus_count
		AudioServer.add_bus()
		AudioServer.set_bus_name(bus_index, character.id)
		AudioServer.set_bus_volume_db(bus_index, -5.0)
		
		var pitch_shift_effect := AudioEffectPitchShift.new()
		pitch_shift_effect.pitch_scale = character.pitch_shift
		pitch_shift_effect.oversampling = 6
		AudioServer.add_bus_effect(bus_index, pitch_shift_effect)
		
		var voice_delay = TimingManager.register_voice(character.voice_range)
		var delay_effect := AudioEffectDelay.new()
		delay_effect.dry = 0
		delay_effect.set('tap1/delay_ms', voice_delay)
		delay_effect.set('tap2/active', false)
		AudioServer.add_bus_effect(bus_index, delay_effect)
	
	return AudioServer.get_bus_index(character.id)


func set_character_volume(character, volume:float) -> void:
	var bus_index = get_character_bus(character)
	AudioServer.set_bus_volume_db(bus_index, volume)
