extends Control

var player_words = []
#var story = "Once upon a time someone called %s ate a %s flavoured sandwich which made him feel all %s inside. It was a %s day"
#var wildcards = ["a name", "a noun", "adverb", "adjective"]

var current_story = {}

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
#For later, thats why onready

onready var DisplayText = $VBoxContainer/DisplayText

func _ready():
	set_current_story()
	DisplayText.text = "Welcome to Loony Lips! We're going to tell a story and have a wonderful time!"	
	check_player_words_length()	
	PlayerText.grab_focus()

func set_current_story():
	var stories = get_from_json("StoryBook.json")
	randomize()
	current_story = stories[randi() % stories.size()]

func get_from_json(filename):
	var file = File.new() #Fileobject
	file.open(filename, File.READ) #reading the file
	var text = file.get_as_text() #reading as text
	var data = parse_json(text) #parsing in data as json
	file.close() #closing the file
	return data #returning the data

func _on_PlayerText_text_entered(new_text):
	add_to_player_words()


func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene() # Reloding the game
	else:	
		add_to_player_words()
	

	
func add_to_player_words():
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()

func is_story_done():
	return player_words.size() == current_story.wildcards.size()
	
func check_player_words_length():
	if is_story_done():
		end_game()
	else:
		wildcards_player()
		
func tell_story():
	DisplayText.text = current_story.story % player_words
	
func wildcards_player():
	DisplayText.text += "May I have " + current_story.wildcards[player_words.size()] + " please?"
				

func end_game():
	PlayerText.queue_free() #Getting rid of PlayerText not termination, it is free
	$VBoxContainer/HBoxContainer/ShowLabel.text = "Again!"
	tell_story()
	
	
	
		

	
	
