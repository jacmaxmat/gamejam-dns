extends Node

const SAVEFILE = "user://savefile.save"

var highscore = 0



func _ready():
	#save_data(highscore)
	if load_data() == null:
		save_data(highscore)

func save_data(content):
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE)
	file.store_var(content)
	file = null

func load_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	if file != null:
		var content = file.get_var()
		highscore = content
		return content
