extends Area2D

signal destroyed

var has_been_destroyed = false

func destroy():
	if !has_been_destroyed:
		destroyed.emit()
		$AnimationPlayer.play("explode")
		has_been_destroyed = true
	else:
		return
