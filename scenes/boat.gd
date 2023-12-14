extends Area2D

signal destroyed(point_value)

@onready var polygon_2d: Polygon2D = $Polygon2D

var has_been_destroyed = false
var direction 
var speed = 100
var point_value = 100

func _ready() -> void:
	if randi_range(0,1) == 0:
		direction = -1
		polygon_2d.scale.x = -1
	else:
		direction = 1
		polygon_2d.scale.x = 1


func _physics_process(delta: float) -> void:
	if has_overlapping_areas():
		direction *= -1
		polygon_2d.scale.x *= -1
	if !has_been_destroyed:
		position.x += speed * delta * direction


func destroy():
	if !has_been_destroyed:
		destroyed.emit(point_value)
		$AnimationPlayer.play("explode")
		has_been_destroyed = true
	else:
		return
