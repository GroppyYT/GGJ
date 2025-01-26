extends CharacterBody2D
var pos:Vector2
var rota:float
var dir : float
var speed = 200

func _ready():
	global_position=pos
	global_rotation=rota



func _process(delta):
	attack()
	await get_tree().create_timer(1).timeout
	queue_free()
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	
func attack():
	var overlapping_objects = $Area2D.get_overlapping_areas()
	#attacking = true
	
		
	for area in overlapping_objects:
		var parent = area.get_parent()
		parent.die()


func _on_timer_timeout() -> void:
	queue_free()
