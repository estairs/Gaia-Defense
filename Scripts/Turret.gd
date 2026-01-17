class_name Turret
extends Node2D

@export_group("Settings")
@export var rotation_speed: float = 3.0
@export var projectile_scene: PackedScene
@export var limit_angle: float = 45.0

@export_group("Inputs")
@export var input_left: String = "p1_left"
@export var input_right: String = "p1_right"
@export var input_shoot: String = "p1_shoot"

@export_group("UI Icons")
@export var icon_left: Texture2D
@export var icon_right: Texture2D
@export var icon_shoot: Texture2D

@onready var rotating_part: Node2D = $RotatingPart 
@onready var sprite: Sprite2D = $RotatingPart/Sprite2D
@onready var muzzle: Marker2D = $RotatingPart/Muzzle
@onready var input_visuals: Node2D = $InputVisuals 

@onready var ui_key_left: Sprite2D = $InputVisuals/Left
@onready var ui_key_right: Sprite2D = $InputVisuals/Right
@onready var ui_key_shoot: Sprite2D = $InputVisuals/Shoot

@onready var sfx_shoot: AudioStreamPlayer2D = $AudioStreamPlayer2D

var limit_rad: float

func _ready():
	limit_rad = deg_to_rad(limit_angle)
	
	if icon_left:
		ui_key_left.texture = icon_left
	if icon_right:
		ui_key_right.texture = icon_right
	if icon_shoot:
		ui_key_shoot.texture = icon_shoot

func _process(delta: float) -> void:
	if visible:
		var direction := Input.get_axis(input_left, input_right)
		
		if direction != 0:
			var new_rotation = rotating_part.rotation + (direction * rotation_speed * delta)
			rotating_part.rotation = clamp(new_rotation, -limit_rad, limit_rad)
			
			if Input.is_action_just_pressed(input_left):
				_animate_key_press(ui_key_left)
			if Input.is_action_just_pressed(input_right):
				_animate_key_press(ui_key_right)

		if Input.is_action_just_pressed(input_shoot):
			_animate_key_press(ui_key_shoot)
			shoot()

func shoot() -> void:
	if projectile_scene == null:
		return
	var bullet = projectile_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = muzzle.global_rotation 
	
	sfx_shoot.pitch_scale = randf_range(0.8, 1.2)
	sfx_shoot.play()
	
	
	apply_recoil()

func apply_recoil() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "offset:y", 5.0, 0.05).as_relative()
	tween.tween_property(sprite, "offset:y", -5.0, 0.05).as_relative()

func _animate_key_press(key_sprite: Sprite2D) -> void:
	if key_sprite.has_meta("active_tween"):
		var old_tween = key_sprite.get_meta("active_tween") as Tween
		if old_tween and old_tween.is_valid():
			old_tween.kill()

	var tween = create_tween()
	key_sprite.set_meta("active_tween", tween)
	
	tween.set_parallel(true) 
	tween.tween_property(key_sprite, "scale", Vector2(0.8, 0.8), 0.05)
	tween.tween_property(key_sprite, "modulate:a", 0.5, 0.05)
	
	tween.chain() 
	
	tween.tween_property(key_sprite, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(key_sprite, "modulate:a", 1.0, 0.1)
