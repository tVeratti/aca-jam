extends Node


signal characters_changed()
signal resources_changed()


var money:int = 100 setget _set_money

# All available resources
var characters:Array = []
var songs:Array = [
	Songs.SINCE_U_BEEN_GONE
]
var outfits:Array = []

# Active for Next Event
var active_characters:Array = []
var active_song
var active_outfit



func try_add_character(character) -> bool:
	if character.cost > money: return false
	money -= character.cost
	
	characters.append(character)
	emit_signal("characters_changed")
	
	return true


func _set_money(value) -> void:
	money = value
	emit_signal("resources_changed")
