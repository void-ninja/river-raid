extends Node2D

signal deleted(old_section_global_position_y)

var boat = preload("res://scenes/boat.tscn")
var helicopter = preload("res://scenes/helicopter.tscn")

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
	if current_frame != 3: spawn_enemies()
	

func spawn_enemies() -> void:
	for i in spawners.get_children():
		var num = randi_range(1,4)
		var enemy
		if num == 1 or num == 2:
			continue
		elif num == 3:
			enemy = boat.instantiate()
		elif num == 4:
			enemy = helicopter.instantiate()
			
		i.add_child(enemy)
		
		if current_frame == 0:
			enemy.global_position = Vector2(randi_range(150,500),i.global_position.y)
		elif current_frame == 1:
			enemy.global_position = Vector2(randi_range(200,425),i.global_position.y)
		elif current_frame == 2:
			if randi_range(0,1) == 0:
				enemy.global_position = Vector2(randi_range(150,200),i.global_position.y)
			else:
				enemy.global_position = Vector2(randi_range(415,500),i.global_position.y)
		
