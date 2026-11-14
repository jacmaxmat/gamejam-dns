extends Sprite2D

@export var target :Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target == null:
		target = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target.global_position + Global.LEVEL_OFFSET
