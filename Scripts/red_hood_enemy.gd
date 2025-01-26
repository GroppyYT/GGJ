extends CharacterBody2D

@onready var animatedsprite = $AnimatedSprite2D
var speed = 60
const JUMP_VELOCITY = -400.0

var facing_right = true

var dead = false


	

func die():
	speed = 0
	animatedsprite.play("Death")
	dead = true
	$Timer.start()
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if $RayCast2D.is_colliding() && !dead:
		
		animatedsprite.play("Attack")
	
	
	if !$groundCheck.is_colliding() && is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()
	
	
func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1


func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead:
		area.get_parent().take_damage(1)
