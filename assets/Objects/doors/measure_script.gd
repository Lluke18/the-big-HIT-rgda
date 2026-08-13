extends MeshInstance3D

func _ready() -> void:
	print(self.get_aabb().size)
