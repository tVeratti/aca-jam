extends Event

const NUM_AUDITIONERS:int = 5
const NAMES_FIRST_PATH:String = "res://Character/names_first.json"
const NAMES_LAST_PATH:String = "res://Character/names_last.json"

var all_names_first:Array = []
var all_names_last:Array = []


var auditioners:Array = []
var current_auditioner
var current_index:int = 0

onready var money_label:Label = get_node("%Money")
onready var characters_box:HBoxContainer = get_node("%Characters")

onready var auditioner_dots:HBoxContainer = $CanvasLayer/Interface/Layout/Auditioners
onready var name_label:Label = get_node("%Name")
onready var cost_label:Label = get_node("%Cost")
onready var voice_label:Label = get_node("%Voice")
onready var traits_box:HBoxContainer = get_node("%Traits")


func _init():
	type = Types.AUDITION


func _ready():
	_load_random_names()
	_generate_auditioners()
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
		
		var dot:ColorRect = ColorRect.new()
		auditioner_dots.add_child(dot)
		dot.rect_min_size = Vector2(10, 10)


func render_auditioner():
	name_label.text = current_auditioner.full_name
	cost_label.text = "$%s" % current_auditioner.cost
	voice_label.text = Character.VoiceRanges.keys()[current_auditioner.voice_range]
	
	for child in traits_box.get_children(): child.queue_free()
	
	for trait in current_auditioner.traits:
		var label = Label.new()
		label.text = "%s\n%s" % [trait.title, trait.description]
		traits_box.add_child(label)
	
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
	current_index += 1
	auditioner_next()


func auditioner_next() -> void:
	if auditioners.empty(): end_audition()
	else:
		if current_index >= auditioners.size(): current_index = 0
		current_auditioner = auditioners[current_index]
		render_auditioner()


func end_audition():
	EventManager.end_event()
	queue_free()


func _remove_auditioner() -> void:
	auditioners.erase(current_auditioner)
	auditioner_dots.remove_child(auditioner_dots.get_child(0))
	if auditioners.empty(): end_audition()


# Node Signals

func _on_Yes_pressed():
	auditioner_yes()


func _on_No_pressed():
	auditioner_no()


func _on_Skip_pressed():
	auditioner_skip()


func _on_Exit_pressed():
	end_audition()
