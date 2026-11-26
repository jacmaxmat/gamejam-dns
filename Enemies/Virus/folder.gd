extends Node2D

@export var file_count: int = 5
@export var merge_time: float = 8.0
@export var bounce_velocity: float = -380.0
@export var min_fall_speed: float = 20.0
@export var file_scene: PackedScene = preload("res://Enemies/Virus/file.tscn")

@onready var area: Area2D = $Area2D

var slotx: int = -1
var sloty: int = -1
var spawner: Node = null
var is_breaking: bool = false
var overlapping_player: Player = null

func _ready() -> void:
	add_to_group("folders")
	if not area.body_entered.is_connected(_on_body_entered):
		area.body_entered.connect(_on_body_entered)
	if not area.body_exited.is_connected(_on_body_exited):
		area.body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if is_breaking or not is_instance_valid(overlapping_player):
		return
	if _can_stomp(overlapping_player):
		_stomp(overlapping_player)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		overlapping_player = body as Player

func _on_body_exited(body: Node2D) -> void:
	if body == overlapping_player:
		overlapping_player = null

func _can_stomp(player: Player) -> bool:
	if player.is_on_floor():
		return false
	if player.velocity.y < min_fall_speed:
		return false
	if player.global_position.y >= global_position.y:
		return false
	return true

func _stomp(player: Player) -> void:
	player.velocity.y = bounce_velocity
	break_folder()

func break_folder() -> void:
	if is_breaking:
		return
	is_breaking = true
	overlapping_player = null
	
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
