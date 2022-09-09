extends Spatial

class_name Character

const MIN_COST:int = 10
const INI_COST:int = 20
const MAX_COST:int = 100

const POSITIVE_TRAIT_COST:int = 10
const NEGATIVE_TRAIT_COST:int = -10

enum VoiceRanges { SOPRANO, ALTO, BASS } # TODO: Re-add TENOR


export(String) var first_name:String = ""
export(String) var last_name:String = ""
export(int) var cost:int = INI_COST

export(VoiceRanges) var voice_range:int = VoiceRanges.SOPRANO
export(float) var pitch_shift:float = 1.0
export(float) var chorus_delay_ms:float = 0.0

var id:String setget , _get_id
var full_name:String setget , _get_full_name
var voice_label:String setget , _get_voice_label

var level:int = 1
var traits:Array = []


func generate() -> void:
	voice_range = Random.get_random_item(VoiceRanges.values())
	
	# Shift pitch by octaves instead of random amounts
	var octave_shift:int = (randi() % 3) + 1
	match(octave_shift):
		1: pitch_shift = 0.25 # down 2 octave
		2: pitch_shift = 0.50 # down 1 octave
		3: pitch_shift = 1.00 # no change
#		3: pitch_shift = 2.00 # up 1 octave
#		5: pitch_shift = 4.00 # up 2 octave
	
	var pitch_offset:float = rand_range(-0.1, 0.1)
	pitch_shift += pitch_shift
	
	# Generate initial trait(s)
	var ran_trait = TraitManager.get_random_trait()
	traits.append(ran_trait)
	
	for trait in traits:
		match(trait.type):
			Trait.Types.POSITIVE: cost += POSITIVE_TRAIT_COST
			Trait.Types.NEGATIVE: cost += NEGATIVE_TRAIT_COST
	
	var random_cost_mod:int = int(rand_range(-10, 10))
	cost = clamp(cost + random_cost_mod, MIN_COST, MAX_COST)


func _get_id() -> String:
	return "%s_%s" % [first_name, last_name]


func _get_full_name() -> String:
	return "%s %s" % [first_name, last_name]

func _get_voice_label() -> String:
	return VoiceRanges.keys()[voice_range]
