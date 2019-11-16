extends Node2D


var coordinates : Vector2 = Vector2(0,0)
var tile_typ : String = ""
var trap_typ : String = ""


func _ready():
	#print(self.get_path())
	#print(self.get_name())
	pass

func set_sprite_size(sprite_scale):
	$Sprite.scale = Vector2(sprite_scale, sprite_scale)
