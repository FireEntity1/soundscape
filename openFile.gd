extends Button

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

func load_and_play(path):
	$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(path)

func _on_file_open_file_selected(path):
	load_and_play(path)
	print(path)
	dir_contents(path)


func _on_button_up():
	$fileOpen.popup()

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".ogg"):
				if a == null:
					a = path + "/" + file_name
				elif b == null:
					b = path + "/" + file_name
				elif c == null:
					c = path + "/" + file_name
				elif d == null:
					d = path + "/" + file_name
				elif e == null:
					e = path + "/" + file_name
				elif f == null:
					f = path + "/" + file_name
				elif g == null:
					g = path + "/" + file_name
				elif h == null:
					h = path + "/" + file_name
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	load_and_play(a)


func _on_file_open_dir_selected(dir):
	dir_contents(dir)
