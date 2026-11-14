extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Level.global_position = -Global.LEVEL_OFFSET

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.mouse_position = get_global_mouse_position() - Global.LEVEL_OFFSET
