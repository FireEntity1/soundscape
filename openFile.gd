extends Button

var songs = []
var index = 0
var pos = 0
var current = [" "]
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
var bus_index = AudioServer.get_bus_index("Master")
var effect = AudioEffectSpectrumAnalyzer.new()
var bass = 0
var advance = true
var playing
var loop = false

signal color

# Settings
var visualize = true
var shuffle = false

func _ready():
	AudioServer.add_bus_effect(bus_index, effect)

func _process(delta):
	if songs.size() > 0:
		current = (songs[index].split("/"))
		$playing.text = current[current.size()-1]
	if $AudioStreamPlayer2D.playing and advance == true:
		$cursor.max_value = $AudioStreamPlayer2D.stream.get_length()
		$cursor.value = $AudioStreamPlayer2D.get_playback_position()
		$total.text = str(int($AudioStreamPlayer2D.stream.get_length()))
		$done.text = str(int($AudioStreamPlayer2D.get_playback_position()))
		
		spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_index, 0)
		bass = (spectrum_analyzer.get_magnitude_for_frequency_range(20,80).x + spectrum_analyzer.get_magnitude_for_frequency_range(20,80).y)/2

		if visualize: $pulse.color = Color(1-(bass*1.5),1-(bass*1.5),1-(bass*1.5),1)
		else: $pulse.color = Color(1,1,1,1)
	elif advance == false:
		$done.text = str(int($cursor.value))
	$AudioStreamPlayer2D.volume_db = $vol.value


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
		if songs.size() > 0:
			if songs[0].ends_with(".mp3"):
				load_mp3(songs[index])
			elif songs[0].ends_with(".ogg"):
				load_ogg(songs[index])
		else:
			$playing.text = "No songs found, .mp3 and/or .ogg files must be in the given directory"
	else:
		$playing.text = "Error: Can't access directory"


func _on_file_open_dir_selected(dir):
	dir_contents(dir)


func _on_skip_button_up():
	if songs.size() > 0:
		if shuffle == false:
			index += 1
			if index == songs.size():
				index = 0
			index = clamp(index,0,songs.size() -1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs[index])
			else:
				load_ogg(songs[index])
		elif shuffle:
			index = randi_range(0,songs.size()-1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs.pick_random())
			else:
				load_ogg(songs.pick_random())

func _on_back_button_up():
	if songs.size() > 0:
		if shuffle == false:
			index -= 1
			index = clamp(index,0,songs.size() -1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs[index])
			else:
				load_ogg(songs[index])
		elif shuffle:
			index = randi_range(0,songs.size()-1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs.pick_random())
			else:
				load_ogg(songs.pick_random())

func load_ogg(path):
	$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(path)
	$AudioStreamPlayer2D.play()
	$pause.texture_normal = load("res://play.png")
	$pause.texture_hover = load("res://playHov.png")

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()
	$pause.texture_normal = load("res://play.png")
	$pause.texture_hover = load("res://playHov.png")


func _on_pause_button_up():
	if $AudioStreamPlayer2D.playing:
		pos = $AudioStreamPlayer2D.get_playback_position()
		$AudioStreamPlayer2D.stop()
		$pause.texture_normal = load("res://paused.png")
		$pause.texture_hover = load("res://pausedHov.png")
	else:
		$AudioStreamPlayer2D.play(pos)
		$pause.texture_normal = load("res://play.png")
		$pause.texture_hover = load("res://playHov.png")
		


func _on_forward_button_up():
	$AudioStreamPlayer2D.play($AudioStreamPlayer2D.get_playback_position()+10)


func _on_rewind_button_up():
	$AudioStreamPlayer2D.play($AudioStreamPlayer2D.get_playback_position()-10)


func _on_close_button_up():
	get_tree().quit()


func _on_vol_drag_ended(value_changed):
	pass


func _on_cursor_drag_started():
	advance = false


func _on_cursor_drag_ended(value_changed):
	$AudioStreamPlayer2D.play($cursor.value)
	advance = true


func _on_settings_button_button_up():
	$settings.show()


func _on_settings_id_pressed(id):
	$settings.toggle_item_checked(id)
	match id:
		0:
			if visualize == false:
				visualize = true
			else: 
				visualize = false
		1:
			if shuffle == false:
				shuffle = true
			else:
				shuffle = false
		2:
			color.emit(Color(0.1,0.1,0.2,1))
		3:
			color.emit(Color(0.1,0.2,0.1,1))
		4:
			color.emit(Color(0.2,0.1,0.1,1))
		5:
			color.emit(Color(0.1,0.1,0.1,1))
		6:
			color.emit(Color(0.12,0.14,0.18,1))


func _on_audio_stream_player_2d_finished():
	if songs.size() > 0:
		if loop:
			$AudioStreamPlayer2D.play(0)
		elif shuffle == false:
			index += 1
			if index == songs.size():
				index = 0
			index = clamp(index,0,songs.size() -1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs[index])
			else:
				load_ogg(songs[index])
		elif shuffle:
			index = randi_range(0,songs.size()-1)
			if songs[index].ends_with(".mp3"):
				load_mp3(songs.pick_random())
			else:
				load_ogg(songs.pick_random())


func _on_loop_toggled(toggled_on):
	if toggled_on:
		loop = true
		$loop.modulate.b = 0
		$loop.modulate.r = 0
		$loop.modulate.g = 1
	elif not toggled_on:
		loop = false
		$loop.modulate.b = 1
		$loop.modulate.r = 1
		$loop.modulate.g = 1
