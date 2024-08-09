extends Control

var following = false
var dragging_start_position = Vector2()


func _process(_delta):
	if following:
		get_window().position = get_window().position + Vector2i(get_global_mouse_position()) - Vector2i(dragging_start_position)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		following = !following
		dragging_start_position = get_local_mouse_position()
