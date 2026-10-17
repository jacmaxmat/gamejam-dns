extends SubViewportContainer

func _ready() -> void:
	Global.view = $SubViewport
	
func _process(delta: float) -> void:
	$SubViewport/TextureRect.global_position = Vector2(-228,-135)
