extends Control

@onready var audio_stream_player_mmm: AudioStreamPlayer2D = $AudioStreamPlayer_mmm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_mmm.play() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/game.tscn")




func _on_exit_3_pressed() -> void:
	get_tree().quit()
