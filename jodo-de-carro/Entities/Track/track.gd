extends Node2D

class_name Track

@onready var track_path: Path2D = $TrackPath

var track_curve: Curve2D

func _ready() -> void:
	track_curve = track_path.curve
	
func get_direction_to_path(from_pos: Vector2) -> Vector2:
	var closet_offset: float = track_curve.get_closest_offset(from_pos)
	var nearest_point: Vector2 = track_curve.sample_baked(closet_offset)
	return from_pos.direction_to(nearest_point)

func _on_track_collsion_area_entered(area: Area2D) -> void:
	if area is Car: area.hit_boundary(get_direction_to_path(area.position))
