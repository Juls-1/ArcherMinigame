extends CharacterBody2D

var speed = 50 
var health = 100

var dead = false
var player_in_area = false
var player

var slime = preload("res://scene/slime_collectable.tscn")

@export var itemRes: InvItem

func _ready() -> void:
	dead = false

func _physics_process(delta: float) -> void:
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		player = body


func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 50
		take_damage(damage)

func take_damage(damage):
	health -= damage
	if health <= 0 and !dead:
		death()

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	queue_free()
	
	
func drop_slime():
	var slime_instance = slime.instantiate()
	slime_instance.global_position = self.global_position
	get_parent().add_child(slime_instance)
	#player.collect(slime)
	#await get_tree().create_timer(3).timeout


	
