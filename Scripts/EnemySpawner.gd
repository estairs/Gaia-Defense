extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 350.0

var active_lanes: Array[float] = [-90.0] 

var angle_spread_deg: float = 35.0

func _ready() -> void:
	$Timer.timeout.connect(_spawn_enemy)

func activate_lane(angle: float) -> void:
	if not active_lanes.has(angle):
		active_lanes.append(angle) #

func _spawn_enemy() -> void:
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
