extends CanvasLayer

var paused = false
var mouse_pos = Vector2(0, 0)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause()
		
func pause():
	paused = !paused
	visible = paused
	if paused:
		mouse_pos = get_viewport().get_mouse_position()
	else:
		get_viewport().warp_mouse(mouse_pos)
	get_tree().paused = paused

func _on_resume_button_pressed():
	pause()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/title_screen.tscn")
