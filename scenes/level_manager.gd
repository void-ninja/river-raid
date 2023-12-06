extends Node

signal checkpoint

var section = preload("res://scenes/section.tscn")
var bridge = preload("res://scenes/bridge.tscn")

var speed = 300 : 
	set(value):
		speed = clampi(value,100,500)
var VIEWPORT_HEIGHT = 640
var level_length := 2 # goes up by 2 every level
var current_length := 0

func _ready() -> void:
	new_level_section(0)


func _physics_process(delta: float) -> void:
	for i in get_children():
		i.global_position.y += speed * delta


func start() -> void:
	var section2 = section.instantiate()
	section2.global_position = Vector2(0,0-VIEWPORT_HEIGHT)
	section2.deleted.connect(new_section)
	add_child(section2)
	section2.set_frame(0)
	current_length += 1
	

func reset() -> void:
	current_length = 0
	level_length -= 2 # the checkpoints work by not resetting this
	speed = 300
	for i in get_children():
		i.queue_free()


func new_section(old_section_global_position_y):
	if current_length < level_length:
		var current_section = section.instantiate()
		current_section.global_position = Vector2(0, old_section_global_position_y - 2*VIEWPORT_HEIGHT)
		current_section.deleted.connect(new_section)
		add_child(current_section)
		current_section.set_frame(randi_range(0,2))
		current_length += 1
	else:
		# new level
		new_level_section(old_section_global_position_y - 2*VIEWPORT_HEIGHT)
		current_length = 0
		

func new_level_section(global_pos:float):
	
	var start_section = section.instantiate()
	start_section.global_position.y = global_pos
	start_section.deleted.connect(new_section)
	add_child(start_section)
	start_section.set_frame(3)
	
	var start_bridge = bridge.instantiate()
	start_bridge.global_position = Vector2((VIEWPORT_HEIGHT/2),start_section.global_position.y+100)
	add_child(start_bridge)
	start_bridge.destroyed.connect(_on_bridge_destroyed)


func _on_bridge_destroyed():
	level_length += 2
	checkpoint.emit()
