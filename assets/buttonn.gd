extends RigidBody3D

signal clicked

func picked_up():
	$button/AnimationPlayer.play("Cylinder_001Action")
	clicked.emit()
