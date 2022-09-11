extends Event


var practicing_characters:Array = GroupManager.characters
var song:String setget _set_song

onready var duration_timer:Timer = $DurationTimer
onready var progress:ProgressBar = get_node("%PracticeProgress")
onready var song_select:OptionButton = get_node("%Song")


func _init():
	type = Types.PRACTICE


func _ready():
	for option in GroupManager.songs:
		song_select.add_item(option)


func _process(delta):
	if is_instance_valid(duration_timer):
		progress.value = duration_timer.wait_time - duration_timer.time_left


func select_character(character):
	practicing_characters.append(character)


func _set_song(value):
	song = value
	TimingManager.song = song


func begin():
	TimingManager.start()


func _on_Song_item_selected(index):
	song = GroupManager.songs[index]


func _on_Start_pressed():
	duration_timer.start()


func _on_DurationTimer_timeout():
	pass # Replace with function body.
