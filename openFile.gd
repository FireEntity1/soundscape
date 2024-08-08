extends Button

var song
const josh = "/Users/aaravk/Downloads/calm1.ogg"
# Called when the node enters the scene tree for the first time.
	#$AudioStreamPlayer2D.stream = AudioStreamOggVorbis.load_from_file(josh)
func _ready():
	pass

func load_and_play_mp3(file_path):
	# Check if the file exists
	var file = FileAccess
	#if not file.file_exists(file_path):
		#print("Error: File does not exist - ", file_path)
		#return
	
	# Load the MP3 file
	var audio_stream = ResourceLoader.load(file_path, "AudioStreamMP3")
	if audio_stream == null:
		print("Error: Failed to load audio file - ", file_path)
		return
	
	# Get the AudioStreamPlayer node
	var audio_player = $AudioStreamPlayer
	if audio_player == null:
		print("Error: AudioStreamPlayer node not found")
		return
	
	# Set the loaded audio stream and play it
	audio_player.stream = audio_stream
	audio_player.play()



func _on_file_open_file_selected(path):
	load_and_play_mp3(path)


func _on_button_up():
	$fileOpen.popup()
