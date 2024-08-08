extends Button

var songs = []
var index = 0
var a = null
var b= null
var c= null
var d= null
var e= null
var f= null
var g= null
var h= null

func _ready():
	pass

func _process(delta):
	print(index)

func load_and_play(path):
	$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(path)
	$AudioStreamPlayer2D.play()

func _on_file_open_file_selected(path):
	pass

func _on_button_up():
	$fileOpen.popup()

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".ogg"):
				songs.append(path + "/" + file_name)
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
		load_and_play(songs[0])
		
	else:
		print("An error occurred when trying to access the path.")


func _on_file_open_dir_selected(dir):
	dir_contents(dir)


func _on_skip_button_up():
	index += 1
	load_and_play(songs[index])


func _on_back_button_up():
	index -= 1
	load_and_play(songs[index])
