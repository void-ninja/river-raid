extends Area2D

signal destroyed(point_value)

var has_been_destroyed = false
var point_value = 0

func _to_string() -> String:
	return "fuel_depot"


func destroy():
	if !has_been_destroyed:
		destroyed.emit(point_value)
		$AnimationPlayer.play("explode")
		has_been_destroyed = true
	else:
		return
