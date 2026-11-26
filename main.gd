extends Node2D

var on_cd = false

func _process(delta: float) -> void:
	if $BottomHurtZone.has_overlapping_bodies() and !on_cd:
		on_cd = true
		var body = $BottomHurtZone.get_overlapping_bodies()[0]
		body.hit(1)
		body.global_position.y -= 10
		body.velocity.y = -850
		await get_tree().create_timer(0.2).timeout
		on_cd = false

func _on_bottom_hurt_zone_body_entered(body: Node2D) -> void:
	pass
