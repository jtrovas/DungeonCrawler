extends Node3D

@export var Map : PackedScene

const _Cell = preload("res://scenes/cell.tscn")

var cells = []

func _ready():
	generate_map()

func generate_map():
	if not Map is PackedScene: return
	var map = Map.instantiate()
	var tileMap = map.get_tilemap()
	var used_tiles = tileMap.get_used_cells()
	map.free() # We don't need it now that we have the tile data
	for tile in used_tiles:
		var cell = _Cell.instantiate()
		add_child(cell)
		cell.position = Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
		cells.append(cell)
	for cell in cells:
		cell.update_faces(used_tiles)
