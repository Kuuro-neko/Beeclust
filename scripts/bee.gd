extends CharacterBody2D

enum {WAIT, TURN, MEASURE, MOVE}

const SPEED = 300.0

var state = MOVE
var timeToWait = 0.
var direction = Vector2.ZERO

func measure() -> float:
	return Vector2(17,6).distance_to(position) / 200
	
func _ready() -> void:
	state = MOVE
	direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP].pick_random()

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if state == MOVE:
		var collision = move_and_collide(direction * SPEED * delta)
		if collision:
			handle_collision(collision)
		else:
			position += direction * SPEED * delta

	elif state == MEASURE:
		timeToWait = measure()
		state = WAIT

	elif state == WAIT:
		timeToWait -= delta
		if (timeToWait <= 0):
			state = TURN

	elif state == TURN:
		if (direction.x == 0):
			direction.x = [1, -1].pick_random()
			direction.y = 0
		else:
			direction.y = [1, -1].pick_random()
			direction.x = 0
		state = MOVE

	play_anim()
	move_and_slide()

func handle_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	if collider is CharacterBody2D:  
		state = MEASURE
	elif collider.is_in_group("Wall"):  
		state = TURN

func play_anim():
	var anim = $AnimatedSprite2D
	if state == MOVE:
		match direction:
			Vector2.UP: anim.play("bee_walk_back")
			Vector2.DOWN: anim.play("bee_walk_front")
			Vector2.LEFT: anim.play("bee_walk_left")
			Vector2.RIGHT: anim.play("bee_walk_right")
	else:
		match direction:
			Vector2.UP: anim.play("bee_idle_back")
			Vector2.DOWN: anim.play("bee_idle_front")
			Vector2.LEFT: anim.play("bee_idle_left")
			Vector2.RIGHT: anim.play("bee_idle_right")
