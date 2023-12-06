extends Area2D

var speed := 400


func _physics_process(delta: float) -> void:
	position.y -= delta * speed
	if global_position.y < -10:
		queue_free()
	
	if has_overlapping_areas():
		for i in get_overlapping_areas():
			if i.to_string() != "player":
				if i.has_method("destroy"):
					i.destroy()
				
				queue_free()


func _to_string() -> String:
	return "rocket"
