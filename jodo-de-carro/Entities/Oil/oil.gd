extends Area2D

class_name OilHazard

func _ready() -> void:
	await get_tree().create_timer(
		randf_range(3, 5)
	).timeout
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Car: print("oil")
