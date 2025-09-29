extends CharacterBody2D

var speed := 100
var player_state := "idle"

@export var inv: Inv

var bow_equipped := true
var bow_cooldown := true
var arrow_scene := preload("res://scene/arrow.tscn")
var arrow_cooldown_time := 0.5
var mouse_dir := Vector2.ZERO


func _physics_process(delta: float) -> void:
	mouse_dir = (get_global_mouse_position() - global_position).normalized()

	var direction := Input.get_vector("left","right","up","down")

	if Input.is_action_just_pressed("left_mouse") and bow_cooldown and bow_equipped:
		player_state = "shooting"
		shoot_arrow()
	elif direction != Vector2.ZERO and player_state != "shooting":
		player_state = "walking"
	elif player_state != "shooting":
		player_state = "idle"

	var current_speed = speed
	if player_state == "shooting":
		current_speed *= 0.5

	velocity = direction * current_speed
	move_and_slide()

	$Marker2D.look_at(get_global_mouse_position())

	play_anim(direction)


func shoot_arrow() -> void:
	bow_cooldown = false

	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.rotation = $Marker2D.rotation
	arrow_instance.global_position = $Marker2D.global_position
	add_child(arrow_instance)

	await get_tree().create_timer(arrow_cooldown_time).timeout
	bow_cooldown = true
	player_state = "idle"


func play_anim(direction: Vector2) -> void:
	match player_state:
		"idle":
			$AnimatedSprite2D.play("idle")

		"walking":
			if direction != Vector2.ZERO:
				var dir = direction.normalized()
				if abs(dir.x) > abs(dir.y):
					if dir.x > 0:
						$AnimatedSprite2D.play("e-walk")
					else:
						$AnimatedSprite2D.play("w-walk")
				else:
					if dir.y > 0:
						$AnimatedSprite2D.play("s-walk")
					else:
						$AnimatedSprite2D.play("n-walk")

				if dir.x > 0.5 and dir.y < -0.5:
					$AnimatedSprite2D.play("ne-walk")
				elif dir.x > 0.5 and dir.y > 0.5:
					$AnimatedSprite2D.play("se-walk")
				elif dir.x < -0.5 and dir.y > 0.5:
					$AnimatedSprite2D.play("sw-walk")
				elif dir.x < -0.5 and dir.y < -0.5:
					$AnimatedSprite2D.play("nw-walk")

		"shooting":
			var dir = mouse_dir
			if abs(dir.x) > abs(dir.y):
				if dir.x > 0:
					$AnimatedSprite2D.play("e-attack")
				else:
					$AnimatedSprite2D.play("w-attack")
			else:
				if dir.y > 0:
					$AnimatedSprite2D.play("s-attack")
				else:
					$AnimatedSprite2D.play("n-attack")

			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-attack")
			elif dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-attack")
			elif dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-attack")
			elif dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-attack")

func collect(item):
	inv.insert(item)

func player():
	pass
