extends SubViewportContainer

var rect_offset = Vector2.ZERO

func _ready() -> void:
	Global.view = $SubViewport
	$SubViewport/TextureRect.global_position = Vector2(-228,-135)
	
func _process(delta: float) -> void:
	pass
	#$SubViewport/TextureRect.size = Vector2(1152,648)
	#$SubViewport/TextureRect.global_position = Vector2(-228,-135)
	#$SubViewport/TextureRect.global_position.x += 1
	#print($SubViewport/TextureRect.size)
