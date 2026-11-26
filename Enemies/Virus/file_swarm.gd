class_name FileSwarm
extends Node

var active_files: Array[Node2D] = []
var spawner: Node = null
var merge_timer: Timer = null
var is_merging: bool = false

func start(origin: Vector2, file_scene: PackedScene, count: int, merge_time: float, folder_spawner: Node) -> void:
	spawner = folder_spawner
	var parent_node: Node = get_parent()
	
	if count <= 0 or file_scene == null:
		_finish_cleared()
		return
	
	for i in count:
		var file_instance: Node2D = file_scene.instantiate() as Node2D
		file_instance.global_position = origin
		parent_node.add_child(file_instance)
		
		var base_angle: float = (TAU / float(count)) * float(i)
		var dir: Vector2 = Vector2.RIGHT.rotated(base_angle + randf_range(-0.35, 0.35))
		file_instance.launch(dir)
		file_instance.destroyed.connect(_on_file_destroyed)
		active_files.append(file_instance)
		
	merge_timer = Timer.new()
	merge_timer.wait_time = merge_time
	merge_timer.one_shot = true
	merge_timer.timeout.connect(_on_merge_timeout)
	add_child(merge_timer)
	merge_timer.start()

func _on_file_destroyed(file: Node2D) -> void:
	active_files.erase(file)
	if active_files.is_empty() and not is_merging:
		if is_instance_valid(merge_timer):
			merge_timer.stop()
		_finish_cleared()

func _finish_cleared() -> void:
	if is_instance_valid(spawner) and spawner.has_method("on_swarm_cleared"):
		spawner.on_swarm_cleared()
	else:
		Global.has_folder = false
	queue_free()

func _on_merge_timeout() -> void:
	var survivors: Array[Node2D] = []
	for f in active_files:
		if is_instance_valid(f):
			survivors.append(f)
			
	if survivors.is_empty():
		_finish_cleared()
		return
		
	is_merging = true
	
	var sum_pos: Vector2 = Vector2.ZERO
	for f in survivors:
		sum_pos += f.global_position
	var avg_pos: Vector2 = sum_pos / float(survivors.size())
	
	var merge_duration: float = 0.25
	for f in survivors:
		if f.has_method("start_merge"):
			f.start_merge(avg_pos, merge_duration)
			
	await get_tree().create_timer(merge_duration).timeout
	
	for f in survivors:
		if is_instance_valid(f):
			f.queue_free()
			
	if is_instance_valid(spawner) and spawner.has_method("spawn_folder_at"):
		spawner.spawn_folder_at(avg_pos)
	else:
		var folder_scene: PackedScene = load("res://Enemies/Virus/folder.tscn") as PackedScene
		var new_folder: Node2D = folder_scene.instantiate() as Node2D
		new_folder.global_position = avg_pos
		get_parent().add_child(new_folder)
		
	queue_free()
