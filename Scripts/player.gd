class_name Player

extends CharacterBody2D

var SPEED = 250.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var bubble_shielder = $AnimatedSprite2D/bubbleShielder  
@onready var splashZone = $AnimatedSprite2D/SplashZone/CollisionShape2D

@export var attacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_health = 3
var health = 0
var canTakeDamage = true

var is_shielding = false

func die():
	SPEED = 0
	animated_sprite.play("Death")
	$Timer.start()

func attack():
	var overlapping_objects = $AnimatedSprite2D/SplashZone.get_overlapping_areas()
	attacking = true
	
		
	for area in overlapping_objects:
		var parent = area.get_parent()
		parent.die()
	
	

func _ready():
	
	health = max_health
	
	if not animated_sprite:
		push_error("AnimatedSprite2D not found")
	if not bubble_shielder:
		push_error("BubbleShielder not found")
	else:
		# Ensure BubbleShielder starts hidden
		bubble_shielder.visible = false
		
func _process(delta):
	
		
	if Input.is_action_just_pressed("LeftClick"):
		attack()
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction > 0:
			animated_sprite.flip_h = false
			if bubble_shielder:
				bubble_shielder.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
			if bubble_shielder:
				bubble_shielder.flip_h = true
	else:
		animated_sprite.play("Jumping")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Check if the left mouse button is pressed or released
	if Input.is_action_pressed("LeftClick"):
		attacking = true
		is_shielding = true
		if bubble_shielder:
			splashZone.disabled = false
			bubble_shielder.visible = true  # Show the BubbleShielder
			bubble_shielder.play("default")  # Play the BubbleShielder's animation
	elif Input.is_action_just_released("LeftClick"):
		attacking = false
		is_shielding = false
		if bubble_shielder:
			bubble_shielder.visible = false  # Hide the BubbleShielder
			bubble_shielder.stop()  # Stop the BubbleShielder's animation

	# Play the appropriate animation based on state
	if is_shielding:
		animated_sprite.play("BubbleShield")
	elif velocity.x != 0:
		animated_sprite.play("running")
	elif velocity.x == 0 and is_on_floor():
		animated_sprite.play("idle")

	move_and_slide()

func iFrames():
	canTakeDamage = false
	await get_tree().create_timer(1).timeout
	canTakeDamage = true

func take_damage(damageAmount : int):
	
	if canTakeDamage:
		health -= damageAmount
		
		if health <= 0:
			die()

func _on_timer_timeout() -> void:
	queue_free()
