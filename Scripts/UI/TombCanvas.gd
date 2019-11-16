extends Control

onready var start_sprite = preload("res://Sprites/sprite_start.png")
onready var end_sprite = preload("res://Sprites/sprite_goal.png")
onready var wall_sprite = preload("res://Sprites/sprite_wall.png")
onready var path_sprite = preload("res://Sprites/sprite_path.png")
onready var trap_sprite = preload("res://Sprites/sprite_trap.png")

onready var start_sprite_explored = preload("res://Sprites/sprite_start_explored.png")
onready var end_sprite_explored = preload("res://Sprites/sprite_goal_explored.png")
onready var path_sprite_explored = preload("res://Sprites/sprite_path_explored.png")
onready var trap_sprite_explored = preload("res://Sprites/sprite_trap_explored.png")

onready var canvas_size_x = get_parent().rect_size.x
onready var canvas_size_y = get_parent().rect_size.y

const canvas_margin = 20
const default_tile_offset_y = 60

var tile_size = 0
var tile_offset = 0
var sprite_size_modifier = 0

var mapWidth = 0
var mapHeight = 0
var startNode  = Vector2(0,0)
var endNode  = Vector2(0,0)


func create_map(startNode, endNode, map):
	mapWidth = map.size()
	mapHeight = map[0].size()
	
	# get tile-size
	tile_size = min(int((canvas_size_y - canvas_margin * 2) / (mapHeight + 1)), int((canvas_size_x - canvas_margin * 2) / mapWidth))
	
	tile_offset = Vector2(((canvas_size_x - (mapWidth * tile_size)) / 2),  default_tile_offset_y)
	
	sprite_size_modifier = (float(tile_size) / (64.0 / 100.0) / 100.0)
	
	# instance the tiles
	for i in mapWidth:
		for j in mapHeight:
			if Vector2(i, j) == startNode:
				create_tile(i, j, "startNode")
			elif Vector2(i, j) == endNode:
				create_tile(i, j, "endNode")
			else:
				create_tile(i, j, map[i][j])


func create_tile(x, y, typ):
	# create tile instance
	var scene = load("res://Scenes/MazeObject/MazeObject.tscn")
	var scene_instance = scene.instance()
	
	# set parameters
	if typ == "startNode":
		scene_instance.get_child(0).set_texture(start_sprite)
		scene_instance.tile_typ = "startNode"
	elif typ == "endNode":
		scene_instance.get_child(0).set_texture(end_sprite)
		scene_instance.tile_typ = "endNode"
	elif typ == "x":
		scene_instance.get_child(0).set_texture(wall_sprite)
		scene_instance.tile_typ = "x"
	elif typ == "o":
		scene_instance.get_child(0).set_texture(path_sprite)
		scene_instance.tile_typ = "o"
	else:
		scene_instance.get_child(0).set_texture(trap_sprite)
		scene_instance.get_child(0).get_child(0).text = typ
	
	scene_instance.coordinates = Vector2(x, y)
	scene_instance.set_sprite_size(sprite_size_modifier)
	
	# set position
	scene_instance.position = Vector2((x * tile_size), (y * tile_size)) + tile_offset
	
	# add child
	self.add_child(scene_instance, true)


func draw_final_path(path):
	for tile in path:
		for child in self.get_children():
			if tile == child.coordinates:
				if child.tile_typ == "x":
					continue
				elif child.tile_typ == "o":
					child.get_child(0).set_texture(path_sprite_explored)
				elif child.tile_typ == "startNode":
					child.get_child(0).set_texture(start_sprite_explored)
				elif child.tile_typ == "endNode":
					child.get_child(0).set_texture(end_sprite_explored)
				else:
					child.get_child(0).set_texture(trap_sprite_explored)
	
