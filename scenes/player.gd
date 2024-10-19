extends Node3D

@onready var timerprocessor: = $Timer
@onready var forward: = $RayForward
@onready var back: = $RayBack
@onready var right: = $RayRight
@onready var left: = $RayLeft
#var tween : Tween

func collision_check(direction):
	if direction != null:
		if direction is RayCast3D: print_debug("is raycast")
		print(direction.is_colliding())
		return direction.is_colliding()
	else:
		return false

func get_direction(direction):
	if not direction is RayCast3D: return
	var otherObj = direction.get_collider()
	if otherObj == null: return
	return direction.get_collider().global_transform.origin - global_transform.origin

func _on_Timer_timeout() -> void:
	var GO_W := Input.is_action_pressed("forward")
	var GO_S := Input.is_action_pressed("back")
	var GO_A := Input.is_action_pressed("strafe_left")
	var GO_D := Input.is_action_pressed("strafe_right")
	var TURN_Q := Input.is_action_pressed("turn_left")
	var TURN_E := Input.is_action_pressed("turn_right")
	var ray_dir
	var turn_dir = int(TURN_Q) - int(TURN_E)

	if GO_W: 
		ray_dir = forward
	elif GO_S: 
		ray_dir = back
	elif GO_A: 
		ray_dir = left
	elif GO_D: 
		ray_dir = right
	elif turn_dir:
		timerprocessor.stop()
		#var rot = Vector3(0,PI/2*turn_dir,0)
		await create_tween().tween_property(self, "rotation", rotation + Vector3(0, PI/2*turn_dir, 0), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).finished
		#get_tree().create_tween().tween_property(self, "rotation", rot, .5).finished
		timerprocessor.start()

	if collision_check(ray_dir):
		timerprocessor.stop()
		$AnimationPlayer.play("Step")
		
		await create_tween().tween_property(self, "position", position + get_direction(ray_dir) , 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).finished
		timerprocessor.start()
