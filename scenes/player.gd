extends Area2D

signal speed_up
signal slow_down
signal shoot
signal game_over
signal fuel_update(amount:int)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionPolygon2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var can_shoot : bool = true
var fuel : int = 100 : 
	set(value):
		fuel = clampi(value, 0, 100)
		fuel_update.emit(value)
var fuel_counter : int = 0

func _ready() -> void:
	sprite.frame = 0
	

func _physics_process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
	if Input.is_action_just_pressed("shoot"):
	
		if can_shoot:
			shoot.emit()
			animation_player.stop()
			animation_player.play("shoot")
			can_shoot = false
			
			get_tree().create_timer(0.2).connect("timeout", toggle_can_shoot)
		
	if Input.is_action_pressed("move_left"):
		position.x -= 170 * delta
		rotation_degrees = -30
	elif Input.is_action_pressed("move_right"):
		position.x += 170 * delta
		rotation_degrees = 30
	else:
		rotation_degrees = 0
		
	if Input.is_action_pressed("speed_up"):
		speed_up.emit()
	if Input.is_action_pressed("slow_down"):
		slow_down.emit()
		
	if has_overlapping_areas():
		for i in get_overlapping_areas():
			if i.to_string() == "fuel_depot":
				fuel += 2
				fuel_counter = 0
			elif i.to_string() != "rocket":
				game_over.emit()
				# explode()
	
	fuel_counter += 1
	if fuel_counter > 5:
		fuel -= 1
		fuel_counter = 0
		
	if fuel == 0:
		game_over.emit()


func toggle_can_shoot():
	can_shoot = not can_shoot


func explode() -> void:
	animation_player.stop()
	animation_player.play("explode")


func _to_string() -> String:
	return "player"
