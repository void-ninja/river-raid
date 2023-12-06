extends Control

signal start

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		hide()
		get_tree().paused = false
		start.emit()
