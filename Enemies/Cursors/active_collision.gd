extends TileMapLayer

@export var source_layer: TileMapLayer
@export var mask_margin: Vector2 = Vector2.ZERO

var active_cells: Dictionary = {}
var last_rects: Array[Rect2i] = []

func _ready() -> void:
	if source_layer == null:
		source_layer = get_node_or_null("../Visual2") as TileMapLayer
	if is_instance_valid(source_layer):
		tile_set = source_layer.tile_set
		global_transform = source_layer.global_transform
	clear()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(source_layer):
		return

	if global_transform != source_layer.global_transform:
		global_transform = source_layer.global_transform
		last_rects.clear()

	var windows: Array[Node] = get_tree().get_nodes_in_group("windows")
	var current_rects: Array[Rect2i] = []

	for node in windows:
		if not (node is Node2D):
			continue
		var cell_rect: Rect2i = _get_window_cell_rect(node as Node2D)
		if cell_rect.size.x > 0 and cell_rect.size.y > 0:
			current_rects.append(cell_rect)

	if current_rects == last_rects:
		return
	last_rects = current_rects

	var new_cells: Dictionary = {}
	for rect in current_rects:
		for x in range(rect.position.x, rect.end.x):
			for y in range(rect.position.y, rect.end.y):
				var cell: Vector2i = Vector2i(x, y)
				if source_layer.get_cell_source_id(cell) != -1:
					new_cells[cell] = true

	for cell in active_cells:
		if not new_cells.has(cell):
			erase_cell(cell)

	for cell in new_cells:
		if not active_cells.has(cell):
			set_cell(
				cell,
				source_layer.get_cell_source_id(cell),
				source_layer.get_cell_atlas_coords(cell),
				source_layer.get_cell_alternative_tile(cell)
			)

	active_cells = new_cells

func _get_window_cell_rect(win: Node2D) -> Rect2i:
	var mask_xform: Transform2D
	var local_rect: Rect2

	var light: PointLight2D = win.get_node_or_null("PointLight2D") as PointLight2D
	if light and light.texture:
		var size: Vector2 = light.texture.get_size() * light.texture_scale
		local_rect = Rect2(light.offset - size * 0.5, size)
		mask_xform = light.global_transform
	elif win.get_node_or_null("WindowSprite") is Sprite2D:
		var sprite: Sprite2D = win.get_node("WindowSprite") as Sprite2D
		local_rect = sprite.get_rect()
		mask_xform = sprite.global_transform
	elif win.has_method("get_frame_size"):
		var size: Vector2 = win.get_frame_size()
		local_rect = Rect2(-size * 0.5, size)
		mask_xform = Transform2D(win.global_rotation, win.global_position)
	else:
		return Rect2i()

	local_rect = Rect2(
		local_rect.position + mask_margin,
		local_rect.size - mask_margin * 2.0
	)
	if local_rect.size.x <= 0.0 or local_rect.size.y <= 0.0:
		return Rect2i()

	var corners: Array[Vector2] = [
		local_rect.position,
		Vector2(local_rect.end.x, local_rect.position.y),
		local_rect.end,
		Vector2(local_rect.position.x, local_rect.end.y),
	]

	var min_local: Vector2 = Vector2(INF, INF)
	var max_local: Vector2 = Vector2(-INF, -INF)
	for corner in corners:
		var p: Vector2 = to_local(mask_xform * corner)
		min_local.x = minf(min_local.x, p.x)
		min_local.y = minf(min_local.y, p.y)
		max_local.x = maxf(max_local.x, p.x)
		max_local.y = maxf(max_local.y, p.y)

	var min_cell: Vector2i = local_to_map(min_local)
	var max_cell: Vector2i = local_to_map(max_local)
	return Rect2i(min_cell, max_cell - min_cell + Vector2i.ONE)
