extends Button

var songs = []
var index = 0
var pos = 0
var current = [" "]

func _ready():
	pass

func _process(delta):
	if songs.size() > 0:
		current = (songs[index].split("/"))
		$playing.text = current[current.size()-1]
	if $AudioStreamPlayer2D.playing:
		$cursor.max_value = $AudioStreamPlayer2D.stream.get_length()
		$cursor.value = $AudioStreamPlayer2D.get_playback_position()
		$total.text = str(int($AudioStreamPlayer2D.stream.get_length()))
		$done.text = str(int($AudioStreamPlayer2D.get_playback_position()))


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
			if file_name.ends_with(".mp3") or file_name.ends_with(".ogg"):
				songs.append(path + "/" + file_name)
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
		if songs[0].ends_with(".mp3"):
			load_mp3(songs[index])
		else:
			load_ogg(songs[index])
	else:
		print("An error occurred when trying to access the path.")


func _on_file_open_dir_selected(dir):
	dir_contents(dir)


func _on_skip_button_up():
	index += 1
	index = clamp(index,0,songs.size() -1)
	if songs[index].ends_with(".mp3"):
		load_mp3(songs[index])
	else:
		load_ogg(songs[index])

func _on_back_button_up():
	index -= 1
	index = clamp(index,0,songs.size() -1)
	if songs[index].ends_with(".mp3"):
		load_mp3(songs[index])
	else:
		load_ogg(songs[index])

func load_ogg(path):
	$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(path)
	$AudioStreamPlayer2D.play()
	$pause.text = "⏸︎"

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()
	$pause.text = "⏸︎"


func _on_pause_button_up():
	if $AudioStreamPlayer2D.playing:
		pos = $AudioStreamPlayer2D.get_playback_position()
		$AudioStreamPlayer2D.stop()
		$pause.text = "▶"
	else:
		$AudioStreamPlayer2D.play(pos)
		$pause.text = "⏸︎"


func _on_forward_button_up():
	$AudioStreamPlayer2D.play($AudioStreamPlayer2D.get_playback_position()+10)


func _on_rewind_button_up():
	$AudioStreamPlayer2D.play($AudioStreamPlayer2D.get_playback_position()-10)
