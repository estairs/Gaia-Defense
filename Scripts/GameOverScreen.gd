extends CanvasLayer

@onready var final_score_label: Label = $Background/FinalScoreLabel

func _process(delta: float) -> void:
	if visible:
		if Input.is_action_just_pressed("ui_accept"):
			restart_game()

func show_game_over(score: int) -> void:
	final_score_label.text = "FINAL SCORE: " + str(score)
	
	visible = true
	get_tree().paused = true

func restart_game() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()
