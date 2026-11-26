extends Control

var tutorial_step = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match tutorial_step:
		1:
			if Input.is_action_just_pressed("jump"):
				await get_tree().create_timer(2).timeout
				if tutorial_step ==1:
					tutorial_step+=1
				$Move.visible = false
				$Shoot.visible = true
		2:
			
			if Input.is_action_just_pressed("shoot"):
				await get_tree().create_timer(2).timeout
				if tutorial_step ==2:
					tutorial_step+=1
				$Shoot.visible = false
				$Hook.visible = true
		3:
			if Input.is_action_just_released("dash"):
				await get_tree().create_timer(2).timeout
				if tutorial_step ==3:
					tutorial_step+=1
				$Hook.visible = false
				$General.visible = true
		4:
			
			await get_tree().create_timer(6).timeout
			$General.visible = false
			Global.tutorial_finished()
			queue_free()
