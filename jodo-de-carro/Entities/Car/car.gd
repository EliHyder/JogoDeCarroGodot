extends Area2D

class_name Car

var throttle: float = 0.0
var steer: float = 0.0
var velocity: float = 0
var bounce_tween: Tween
var bounce_target: Vector2 = Vector2.ZERO

@export var speed: float = 30
@export var acceleration: float = 10
@export var fiction: float = 25
@export var steer_strength: float = 6
@export var min_steer_factor: float = .5
@export var bounce_time: float = 0.8
@export var bounce_force: float = 100
@onready var clash_effect: CPUParticles2D = $ClashEffect

func _physics_process(delta: float) -> void:
	calculate_velocity(delta)
	apply_rotation(delta)
	
	position += transform.x * velocity

func calculate_velocity(delta: float) -> void:
	throttle = Input.get_action_strength("accelerate") - Input.get_action_strength("decelerate")
	if throttle:
		velocity = move_toward(velocity, speed, acceleration * delta * throttle)
	else:
		velocity = move_toward(velocity, 0, fiction * delta)


func calculate_steer() -> float:
	return clampf( 1 - pow((abs(velocity) / speed), 2),
	 min_steer_factor,
	 1
	) * steer_strength *  1 if velocity > 0 else -1 if velocity < 0 else 0


func apply_rotation(delta: float) -> void:
	steer = Input.get_axis("left", "right")
	rotate(calculate_steer() * steer * delta)

func bounce_done() -> void:
	set_physics_process(true)
	bounce_tween = null

func bounce(dir_to_path:Vector2) -> void:
	set_physics_process(false)
	velocity = 0
	bounce_target = position + (dir_to_path * bounce_force)
	
	if bounce_tween and bounce_tween.is_running(): bounce_tween.kill()
	
	rotation_degrees = fmod(rotation_degrees, 360)
	bounce_tween = create_tween()
	bounce_tween.set_parallel(true)
	bounce_tween.tween_property(self, "position", bounce_target, bounce_time)
	bounce_tween.tween_property(self, "rotation_degrees", rotation_degrees + 540, bounce_time)
	bounce_tween.set_parallel(false)
	bounce_tween.finished.connect(bounce_done)
	
	
func hit_boundary(dir_to_path:Vector2) -> void:
	clash_effect.restart()
	bounce(dir_to_path)
