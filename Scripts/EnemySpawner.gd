extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 350.0
@export var base_spawn_time: float = 2.0
@export var max_burst_amount: int = 4

var active_lanes: Array[float] = [-90.0] 
var angle_spread_deg: float = 35.0

func _ready() -> void:
	$Timer.wait_time = base_spawn_time
	$Timer.timeout.connect(_on_timer_timeout)

func activate_lane(angle: float) -> void:
	if not active_lanes.has(angle):
		active_lanes.append(angle)

func _on_timer_timeout() -> void:
	var current_score = get_parent().score 
	
	var difficulty_score = min(current_score, 500)

	var enemies_to_spawn = 1 + int(difficulty_score / 250)

	enemies_to_spawn = min(enemies_to_spawn, max_burst_amount) 
	
	var speed_level = int(difficulty_score / 150)
	var new_wait_time = base_spawn_time - (speed_level * 0.10)
	$Timer.wait_time = max(0.5, new_wait_time)
	
	for i in range(enemies_to_spawn):
		spawn_single_enemy()
		await get_tree().create_timer(0.2).timeout

func spawn_single_enemy() -> void:
	if enemy_scene == null:
		return
	
	var chosen_center_angle = active_lanes.pick_random()
	
	var min_angle = chosen_center_angle - angle_spread_deg
	var max_angle = chosen_center_angle + angle_spread_deg
	var random_angle_deg = randf_range(min_angle, max_angle)
	
	var angle_rad = deg_to_rad(random_angle_deg)
	var direction_vector = Vector2(cos(angle_rad), sin(angle_rad))
	var screen_center = Vector2(320, 180)
	var spawn_pos = screen_center + (direction_vector * spawn_radius)
	
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_pos
	add_child(enemy)
