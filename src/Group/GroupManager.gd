extends Node


signal add_character(character)
signal add_song(song)
signal add_outfit(outfit)


var money:int = 100

# All available resources
var characters:Array = []
var songs:Array = []
var outfits:Array = []

# Active for Next Event
var active_characters:Array = []
var active_song
var active_outfit



func try_add_character(character) -> bool:
	if character.cost > money: return false
	money -= character.cost
	
	characters.append(character)
	emit_signal("add_character", character)
	
	return true
