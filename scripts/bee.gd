extends CharacterBody2D

enum {WAIT, TURN, MEASURE, MOVE}

const SPEED = 300.0

@export var target: Node2D
@export var up_left_corner: Node2D
@export var up_right_corner: Node2D
@export var down_left_corner: Node2D
@export var down_right_corner: Node2D
@export var heatmap: Control

var wave_amplitude = 75.0
var wave_frequency = 25.0 
var wave_offset = randf() * TAU

var state = MOVE
var timeToWait = 0.
var direction = Vector2.ZERO
var maxDistance

func measure() -> float:
	var proximityRatio = 1-target.position.distance_to(position) / maxDistance
	var t = proximityRatio*proximityRatio*proximityRatio*4
	# print("proximity : ", proximityRatio, " t : ", t)
	return t
	
func _ready() -> void:
	state = MOVE
	maxDistance = max(
		target.position.distance_to(up_left_corner.position),
		target.position.distance_to(up_right_corner.position),
		target.position.distance_to(down_left_corner.position),
		target.position.distance_to(down_right_corner.position)
	)
	direction = Vector2.RIGHT.rotated(randf() * TAU).normalized()

func _physics_process(delta: float) -> void:
	if state == MOVE:
		var perp = Vector2(-direction.y, direction.x)
		var wave_offset_amount = sin(Time.get_ticks_msec() * 0.001 * wave_frequency + wave_offset) * wave_amplitude
		var move_vector = (direction * SPEED + perp * wave_offset_amount) * delta
		var collision = move_and_collide(move_vector)
		if collision:
			handle_collision(collision)

	elif state == MEASURE:
		timeToWait = measure()
		state = WAIT

	elif state == WAIT:
		timeToWait -= delta
		if (timeToWait <= 0):
			state = TURN

	elif state == TURN:
		turn_direction()
		state = MOVE
		
	if(heatmap):
		heatmap.store_bee_position(position)
	
	play_anim()

func turn_direction():
	var side = randi_range(0,1)
	var angle
	if side == 1:
		angle = randf_range(PI/3, 2*PI/3)
	else:
		angle = randf_range(4*PI/3, 5*PI/3)
	direction = direction.rotated(angle).normalized()

func handle_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	if collider is CharacterBody2D:  
		state = MEASURE
	elif collider.is_in_group("Wall"):  
		state = TURN

func play_anim():
	if not has_node("AnimatedSprite2D"):
		return
		
	var anim = $AnimatedSprite2D
	var angle = direction.angle()

	if state == MOVE:
		if -PI/4 <= angle and angle < PI/4:
			anim.play("bee_walk_right")
		elif PI/4 <= angle and angle < 3*PI/4:
			anim.play("bee_walk_front")
		elif -3*PI/4 <= angle and angle < -PI/4:
			anim.play("bee_walk_back")
		else:
			anim.play("bee_walk_left")
	else:
		if -PI/4 <= angle and angle < PI/4:
			anim.play("bee_idle_right")
		elif PI/4 <= angle and angle < 3*PI/4:
			anim.play("bee_idle_front")
		elif -3*PI/4 <= angle and angle < -PI/4:
			anim.play("bee_idle_back")
		else:
			anim.play("bee_idle_left")
