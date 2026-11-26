extends Node2D

@export var file_count: int = 5
@export var merge_time: float = 8.0
@export var file_scene: PackedScene = preload("res://Enemies/Virus/file.tscn")

var slotx: int = -1
var sloty: int = -1
var spawner: Node = null
var is_breaking: bool = false

func _ready() -> void:
	add_to_group("folders")

func break_folder() -> void:
	if is_breaking:
		return
	is_breaking = true
	
	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("kablow"):
		$AnimationPlayer.play("kablow")
		await $AnimationPlayer.animation_finished
		
	if slotx >= 0 and sloty >= 0:
		Global.icons.erase([slotx, sloty])
		
	var container: Node = get_tree().current_scene if get_tree().current_scene else get_tree().root
	var swarm: FileSwarm = FileSwarm.new()
	container.add_child(swarm)
	swarm.start(global_position, file_scene, file_count, merge_time, spawner)
	
	queue_free()
