extends Area2D

var start_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_size = $WindowView.size

func _process(delta: float) -> void:
	$CollisionShape2D.shape.size = $WindowView.size
	if $CollisionShape2D.shape.size != start_size:
		$WindowView/Sprite2D2.visible=false
