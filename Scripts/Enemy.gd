class_name Enemy
extends Area2D

@onready var sfx_explode: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


@export var speed: float = 80.0

var target_position: Vector2 = Vector2(320, 180) 

func _ready() -> void:
	look_at(target_position)

func _physics_process(delta: float) -> void:

	position += transform.x * speed * delta
	

	if position.distance_to(target_position) < 10.0:
		_hit_earth()

func die() -> void:
	SignalBus.enemy_died.emit(1)

	sfx_explode.pitch_scale = randf_range(0.8, 1.2)
	sfx_explode.play()

	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	
	set_physics_process(false)
	
	await sfx_explode.finished
	
	queue_free()

func _hit_earth() -> void:
	queue_free()

func _spawn_explosion() -> void:
	pass
