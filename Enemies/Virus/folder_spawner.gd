extends Node2D

@export var files_per_folder: int = 5
@export var merge_time: float = 8.0
@export var screen_size: Vector2 = Vector2(1920.0, 1080.0)
@export var edge_margin: Vector2 = Vector2(60.0, 50.0)
@export var folder_footprint: Vector2 = Vector2(85.0, 60.0)

var folder_preload: PackedScene = preload("res://Enemies/Virus/folder.tscn")

func _ready() -> void:
	$FolderTimer.start()

func spawn_folder() -> void:
	if Global.has_folder:
		return

	var valid_slots: Array[Vector2i] = []
	for x in range(0, 13):
		for y in range(0, 7):
			if Global.icons.has([x, y]):
				continue
			var candidate_pos: Vector2 = Vector2(65.0 + x * 145.0, 55.0 + y * 150.0)
			if not _is_blocked_by_map(candidate_pos):
				valid_slots.append(Vector2i(x, y))

	if valid_slots.is_empty():
		$FolderTimer.start()
		return

	var chosen: Vector2i = valid_slots.pick_random()
	var pos: Vector2 = Vector2(65.0 + chosen.x * 145.0, 55.0 + chosen.y * 150.0)
	var folder_instance: Node2D = _create_folder(pos)
	folder_instance.slotx = chosen.x
	folder_instance.sloty = chosen.y
	Global.icons.append([chosen.x, chosen.y])

func spawn_folder_at(pos: Vector2) -> void:
	var clamped_pos: Vector2 = _clamp_to_screen(pos)
	var free_pos: Vector2 = _find_nearest_free_pos(clamped_pos)
	_create_folder(free_pos)

func _clamp_to_screen(pos: Vector2) -> Vector2:
	return Vector2(
		clampf(pos.x, edge_margin.x, screen_size.x - edge_margin.x),
		clampf(pos.y, edge_margin.y, screen_size.y - edge_margin.y)
	)

func _is_blocked_by_map(world_pos: Vector2) -> bool:
	var half: Vector2 = folder_footprint * 0.5
	var map_layers: Array[Node] = get_tree().get_nodes_in_group("map_tiles")

	for node in map_layers:
		var layer: TileMapLayer = node as TileMapLayer
		if layer == null:
			continue

		var p1: Vector2 = layer.to_local(world_pos - half)
		var p2: Vector2 = layer.to_local(world_pos + half)
		var c1: Vector2i = layer.local_to_map(p1)
		var c2: Vector2i = layer.local_to_map(p2)

		var min_x: int = mini(c1.x, c2.x)
		var max_x: int = maxi(c1.x, c2.x)
		var min_y: int = mini(c1.y, c2.y)
		var max_y: int = maxi(c1.y, c2.y)

		for x in range(min_x, max_x + 1):
			for y in range(min_y, max_y + 1):
				var tile_data: TileData = layer.get_cell_tile_data(Vector2i(x, y))
				if tile_data != null and tile_data.get_collision_polygons_count(0) > 0:
					return true
	return false

func _find_nearest_free_pos(origin: Vector2) -> Vector2:
	if not _is_blocked_by_map(origin):
		return origin

	var step: float = 32.0
	for ring in range(1, 25):
		var radius: float = step * float(ring)
		var samples: int = ring * 8
		for i in range(samples):
			var angle: float = (TAU / float(samples)) * float(i)
			var candidate: Vector2 = _clamp_to_screen(origin + Vector2.RIGHT.rotated(angle) * radius)
			if not _is_blocked_by_map(candidate):
				return candidate
	return origin

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
