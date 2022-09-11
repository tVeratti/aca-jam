extends Event

const NUM_AUDITIONERS:int = 5
const NAMES_FIRST_PATH:String = "res://Character/names_first.json"
const NAMES_LAST_PATH:String = "res://Character/names_last.json"

const CharacterPerformingScene = preload("res://Character/CharacterPerforming.tscn")

var all_names_first:Array = []
var all_names_last:Array = []


var auditioners:Array = []
var current_auditioner
var current_index:int = 0
var all_sing:bool = true setget _set_all_sing

var song:String = Songs.SINCE_U_BEEN_GONE

# Character Nodes
onready var characters_performing = $Characters

# Interface Nodes
onready var money_label:Label = get_node("%Money")
onready var characters_box:HBoxContainer = get_node("%Characters")
onready var auditioner_dots:HBoxContainer = $CanvasLayer/Interface/Layout/Auditioners
onready var portrait = get_node("%Portrait")
onready var cost_label:Label = get_node("%Cost")


func _init():
	type = Types.AUDITION


func _ready():
	_load_random_names()
	_generate_auditioners()
	
	TimingManager.song = song
	TimingManager.start()
	
	render_group()
	auditioner_next()


func _load_random_names():
	var file = File.new()
	
	file.open(NAMES_FIRST_PATH, File.READ)
	all_names_first = parse_json(file.get_as_text())
	file.close()
	
	file.open(NAMES_LAST_PATH, File.READ)
	all_names_last = parse_json(file.get_as_text())


func _generate_auditioners():
	for index in range(NUM_AUDITIONERS):
		var auditioner = Character.new()
		auditioner.generate()
		auditioner.first_name = Random.get_random_item(all_names_first)
		auditioner.last_name = Random.get_random_item(all_names_last)
		auditioners.append(auditioner)
		
		var performing = CharacterPerformingScene.instance()
		performing.character = auditioner
		performing.song = song
		characters_performing.add_child(performing)
		
		var dot:ColorRect = ColorRect.new()
		auditioner_dots.add_child(dot)
		dot.rect_min_size = Vector2(10, 10)
	
	if all_sing:
		for performer in characters_performing.get_children():
			BusManager.set_character_volume(performer.character, BusManager.QUIET_VOLUME)
			performer.sing(true)


func render_auditioner():
	portrait.character = current_auditioner
	cost_label.text = "$%s" % current_auditioner.cost
	
	for dot in auditioner_dots.get_children(): dot.color = Color.darkgray
	auditioner_dots.get_child(current_index).color = Color.white


func render_group() -> void:
	money_label.text = String(GroupManager.money)
	
	for character in GroupManager.characters:
		if not characters_box.has_node(character.id):
			var label:Label = Label.new()
			label.text = character.full_name
			characters_box.add_child(label)
			label.set_name(character.id)
	

func auditioner_yes():
	if GroupManager.try_add_character(current_auditioner):
		_remove_auditioner()
		render_group()
		auditioner_next()


func auditioner_no():
	_remove_auditioner()
	auditioner_next()


func auditioner_skip() -> void:
	var performer = characters_performing.get_node(current_auditioner.id)
	BusManager.set_character_volume(performer.character, BusManager.QUIET_VOLUME)
	
	if not all_sing:
		performer.sing(false)
	
	current_index += 1
	auditioner_next()


func auditioner_next() -> void:
	if auditioners.empty(): end_audition()
	else:
		if current_index >= auditioners.size(): current_index = 0
		current_auditioner = auditioners[current_index]
		render_auditioner()
		
		var character_performing = characters_performing.get_node(current_auditioner.id)
		if not all_sing:
			character_performing.sing(true)
			
		BusManager.set_character_volume(character_performing.character, BusManager.DEFAULT_VOLUME)


func end_audition():
	for remainder in auditioners:
		var bus_index:int = AudioServer.get_bus_index(remainder.id)
		AudioServer.remove_bus(bus_index)
	
	EventManager.end_event()
	queue_free()


func _remove_auditioner() -> void:
	auditioners.erase(current_auditioner)
	auditioner_dots.remove_child(auditioner_dots.get_child(0))
	characters_performing.remove_child(characters_performing.get_node(current_auditioner.id))
	
	var bus_index:int = AudioServer.get_bus_index(current_auditioner.id)
	AudioServer.remove_bus(bus_index)
	
	if auditioners.empty(): end_audition()


func _set_all_sing(value):
	if all_sing == value: return
	all_sing = value
	
	if all_sing:
		for performer in characters_performing.get_children():
			var volume = BusManager.QUIET_VOLUME \
				if performer.character.id != current_auditioner.id else \
				BusManager.DEFAULT_VOLUME
			
			BusManager.set_character_volume(performer.character, volume)
			performer.sing(true)
	else:
		for performer in characters_performing.get_children():
			if current_auditioner.id == performer.character.id:
				BusManager.set_character_volume(performer.character, BusManager.DEFAULT_VOLUME)
			else:
				performer.sing(false)
			

# Node Signals

func _on_Yes_pressed():
	auditioner_yes()


func _on_No_pressed():
	auditioner_no()


func _on_Skip_pressed():
	auditioner_skip()


func _on_Exit_pressed():
	end_audition()


func _on_AllSing_toggled(button_pressed):
	self.all_sing = button_pressed
