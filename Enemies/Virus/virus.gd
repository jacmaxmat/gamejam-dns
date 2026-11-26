extends CanvasLayer

var health: float = 30.0
var hp_preload = preload("uid://dy2mw8dojmse2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.virus_hp = self
	for i in health:
		var hp_instance = hp_preload.instantiate()
		$Path2D.add_child(hp_instance)
		hp_instance.progress_ratio = float(i/health)


func remove_hp():
	$Path2D.get_child(get_child_count()-1).queue_free()
	$Head.play("hurt")


func _on_head_animation_finished() -> void:
	$Head.play("default")
