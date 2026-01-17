class_name Bullet
extends Area2D

@export var speed: float = 600.0 #

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free) 
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		if area.has_method("die"):
			area.die()
		queue_free()
