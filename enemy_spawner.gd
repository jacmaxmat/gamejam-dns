extends Node2D


@onready var enemy_preload = preload("uid://dt2rugap4nnh8")
@onready var enemy_flying_preload = preload("uid://ykqpjllv8oe8")

@onready var enemies = [enemy_preload, enemy_flying_preload]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var enemy_instance = enemies[randi_range(0,enemies.size()-1)].instantiate()
	$Path2D/PathFollow2D.progress_ratio = randf_range(0,1)
	enemy_instance.global_position = $Path2D/PathFollow2D/SpawnPoint.global_position
	get_tree().get_root().add_child(enemy_instance)
