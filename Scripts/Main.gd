extends Node2D

@onready var score_label: Label = $ScoreLabel
@onready var spawner: Node = $EnemySpawner
@onready var game_over_screen: CanvasLayer = $GameOverScreen

@onready var turret_bottom: Node2D = $Earth/TurretBot
@onready var turret_right: Node2D = $Earth/TurretRight
@onready var turret_left: Node2D = $Earth/TurretLeft

@onready var base_bottom: Node2D = $Earth/BaseBottom
@onready var base_right: Node2D = $Earth/BaseRight
@onready var base_left: Node2D = $Earth/BaseLeft

var score: int = 0

func _ready() -> void:
	base_bottom.visible = false
	base_right.visible = false
	base_left.visible = false
	
	update_score_text()
	SignalBus.enemy_died.connect(_on_enemy_died)
	SignalBus.game_over_triggered.connect(_on_game_over)

func _on_enemy_died(points: int) -> void:
	score += points
	update_score_text()
	check_progression()

func update_score_text() -> void:
	score_label.text = "SCORE: " + str(score)

func check_progression() -> void:
	if score >= 10 and score < 20: 
		unlock_turret(turret_bottom, base_bottom, 90.0)
	
	elif score >= 20 and score < 30:
		unlock_turret(turret_right, base_right, 0.0) 

	elif score >= 30:
		unlock_turret(turret_left, base_left, 180.0)

func unlock_turret(turret: Node2D, base: Node2D, lane_angle: float) -> void:
	if turret.visible: return 
	
	print("ALERTA: NOVA AMEAÇA NO ÂNGULO ", lane_angle)
	
	turret.visible = true
	turret.process_mode = Node.PROCESS_MODE_INHERIT
	
	if base:
		base.visible = true
		
		var tween = create_tween()
		base.scale = Vector2(0, 0)
		tween.tween_property(base, "scale", Vector2(1.5, 1.5), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	spawner.activate_lane(lane_angle)
	
func _on_game_over() -> void:
	game_over_screen.show_game_over(score)
