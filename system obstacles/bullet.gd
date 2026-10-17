extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 100 * delta
	$SubViewportContainer/SubViewport.size = Global.window.frame.size
	#$SubViewportContainer/SubViewport/Camera2D.global_position = Global.cam.global_position
