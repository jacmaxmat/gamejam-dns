extends TileMapLayer

@export var source_layer: TileMapLayer
@export var mask_margin: Vector2 = Vector2.ZERO

var active_cells: Dictionary = {}
var last_rects: Array[Rect2i] = []

func _ready() -> void:
	clear()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(source_layer):
		return
		
	var windows: Array[Node] = get_tree().get_nodes_in_group("windows")
	var current_rects: Array[Rect2i] = []
	
	for node in windows:
		if not (node is Node2D) or not node.has_method("get_frame_size"):
			continue
		var win: Node2D = node as Node2D
		var half: Vector2 = (win.get_frame_size() * 0.5) - mask_margin
		var top_left: Vector2 = to_local(win.global_position - half)
		var bottom_right: Vector2 = to_local(win.global_position + half)
		var min_cell: Vector2i = local_to_map(top_left)
		var max_cell: Vector2i = local_to_map(bottom_right)
		current_rects.append(Rect2i(min_cell, max_cell - min_cell + Vector2i.ONE))
	
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
