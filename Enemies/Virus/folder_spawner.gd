extends Node2D

@export var files_per_folder: int = 5
@export var merge_time: float = 8.0
@export var screen_size: Vector2 = Vector2(1920.0, 1080.0)
@export var edge_margin: Vector2 = Vector2(60.0, 50.0)

var folder_preload: PackedScene = preload("res://Enemies/Virus/folder.tscn")

func _ready() -> void:
	$FolderTimer.start()

func spawn_folder() -> void:
	if Global.has_folder:
		return
		
	var slotx: int = randi_range(0, 12)
	var sloty: int = randi_range(0, 6)
	for _i in 15:
		if not Global.icons.has([slotx, sloty]):
			break
		slotx = randi_range(0, 12)
		sloty = randi_range(0, 6)
		
	var pos: Vector2 = Vector2(65.0 + slotx * 145.0, 55.0 + sloty * 150.0)
	var folder_instance: Node2D = _create_folder(pos)
	folder_instance.slotx = slotx
	folder_instance.sloty = sloty
	Global.icons.append([slotx, sloty])

func spawn_folder_at(pos: Vector2) -> void:
	var clamped_pos: Vector2 = Vector2(
		clampf(pos.x, edge_margin.x, screen_size.x - edge_margin.x),
		clampf(pos.y, edge_margin.y, screen_size.y - edge_margin.y)
	)
	_create_folder(clamped_pos)

func _create_folder(pos: Vector2) -> Node2D:
	var folder_instance: Node2D = folder_preload.instantiate() as Node2D
	folder_instance.global_position = pos
	folder_instance.file_count = files_per_folder
	folder_instance.merge_time = merge_time
	folder_instance.spawner = self
	
	var container: Node = get_tree().current_scene if get_tree().current_scene else get_tree().root
	container.add_child(folder_instance)
	Global.has_folder = true
	return folder_instance

func on_swarm_cleared() -> void:
	Global.has_folder = false
	$FolderTimer.start()

func _on_folder_timer_timeout() -> void:
	spawn_folder()
