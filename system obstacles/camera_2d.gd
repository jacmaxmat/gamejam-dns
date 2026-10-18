extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.cam = self
	global_position = get_parent().get_parent().get_parent().global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	global_position = get_parent().get_parent().get_parent().global_position
