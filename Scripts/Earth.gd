class_name Earth
extends Area2D

# Configurações
@export var max_health: int = 2
@onready var current_health: int = max_health

@onready var sprite: Sprite2D = $Sprite2D
@onready var sfx_hurt: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	area_entered.connect(_on_area_entered) #

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		take_damage()
		area.queue_free()

func take_damage() -> void:
	current_health -= 1
	sfx_hurt.pitch_scale = randf_range(0.9, 1.1)
	sfx_hurt.play()
	
	_play_hurt_effect()
	
	if current_health <= 0:
		die()

func die() -> void:
	SignalBus.game_over_triggered.emit()
	
func _play_hurt_effect() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color("00ffff"), 0.1) 
	
	# Opcional: Adicionar Screen Shake aqui futuramente
