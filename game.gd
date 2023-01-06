extends Node
# This script runs in every scene. It is assigned to the Game function and
# uses godot's AutoLoad function. This makes it som i use this scripts
# functions everywhere. This is nice because i use it to save the players
# progress.


const file_name = "user://save.json" 
#user:// is used to refer to the outside of the executable


# This dictionary is saved as a JSON. it makes it easy to save and load.
# It will currently just save the players highscore
export var player = {
	"highscore": 0,
}

# The player dict will be savet saved
func save_data():
	var file = File.new() # makes a variable that can take in a file
	file.open(file_name, File.WRITE) # assigns the file so it can write to the file
	file.store_string(to_json(player)) # saves the 
	file.close() # closes the file for resource purposes.

# Load data will take the file_name and try to assign
# the json information to the player dict.
func load_data():
	var file = File.new() 
	if file.file_exists(file_name):
		file.open(file_name, File.READ) # opens the file in read only
		var data = parse_json(file.get_as_text()) # converts the json to dict and assigns it to data
		file.close()
		if typeof(data) == TYPE_DICTIONARY: # if data converted succesfully
			player = data # put it inside the player dict
		else:
			print("failed to convert data")
	else:
		print("didn't find the save")
