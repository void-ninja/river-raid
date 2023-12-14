extends Node2D

signal deleted(old_section_global_position_y)
signal add_points(amount)

var boat = preload("res://scenes/boat.tscn")
var helicopter = preload("res://scenes/helicopter.tscn")
var fuel_depot = preload("res://scenes/fuel_depot.tscn")

var current_frame = 0
var has_recycled := false

@onready var side_collider_right: CollisionShape2D = $SectionCollider/SideColliderRight
@onready var side_collider_left: CollisionShape2D = $SectionCollider/SideColliderLeft
@onready var frame_1_collider_left: CollisionPolygon2D = $SectionCollider/Frame1ColliderLeft
@onready var frame_1_collider_right: CollisionPolygon2D = $SectionCollider/Frame1ColliderRight
@onready var frame_2_collider: CollisionPolygon2D = $SectionCollider/Frame2Collider
@onready var frame_3_collider_left: CollisionPolygon2D = $SectionCollider/Frame3ColliderLeft
@onready var frame_3_collider_right: CollisionPolygon2D = $SectionCollider/Frame3ColliderRight
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var spawners: Node2D = $Spawners


func _physics_process(_delta: float) -> void:
	if global_position.y > 600 and has_recycled == false:
		deleted.emit(global_position.y)
		has_recycled = true
	if global_position.y > 700:
		queue_free()


func set_frame(frame_to_set:int):
	if -1 < frame_to_set and frame_to_set < 4:
		current_frame = frame_to_set
		if current_frame == 0:
			sprite_2d.frame = 0
			frame_1_collider_left.disabled = true
			frame_1_collider_right.disabled = true
			frame_2_collider.disabled = true
			frame_3_collider_left.disabled = true
			frame_3_collider_right.disabled = true
		if current_frame == 1:
			sprite_2d.frame = 1
			frame_1_collider_left.disabled = false
			frame_1_collider_right.disabled = false
			frame_2_collider.disabled = true
			frame_3_collider_left.disabled = true
			frame_3_collider_right.disabled = true
		if current_frame == 2:
			sprite_2d.frame = 2
			frame_1_collider_left.disabled = true
			frame_1_collider_right.disabled = true
			frame_2_collider.disabled = false
			frame_3_collider_left.disabled = true
			frame_3_collider_right.disabled = true
		if current_frame == 3:
			sprite_2d.frame = 3
			frame_1_collider_left.disabled = true
			frame_1_collider_right.disabled = true
			frame_2_collider.disabled = true
			frame_3_collider_left.disabled = false
			frame_3_collider_right.disabled = false
	else:
		print_debug("set_frame out of range")
	if current_frame != 3: spawn_things()
	

func spawn_things() -> void:
	for i in spawners.get_children():
		var num = randi_range(1,4)
		var thing
		if num == 1:
			continue
		elif num == 2:
			thing = fuel_depot.instantiate()
		elif num == 3:
			thing = boat.instantiate()
		elif num == 4:
			thing = helicopter.instantiate()
			
		i.add_child(thing)
		thing.destroyed.connect(on_thing_destroyed)
		
		if current_frame == 0:
			thing.global_position = Vector2(randi_range(200,420),i.global_position.y)
		elif current_frame == 1:
			thing.global_position = Vector2(randi_range(250,380),i.global_position.y)
		elif current_frame == 2:
			if randi_range(0,1) == 0:
				thing.global_position = Vector2(randi_range(170,190),i.global_position.y)
			else:
				thing.global_position = Vector2(randi_range(440,470),i.global_position.y)


func on_thing_destroyed(point_value):
	add_points.emit(point_value)
