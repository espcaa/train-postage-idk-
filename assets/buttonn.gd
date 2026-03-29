extends RigidBody3D


func picked_up():
	$button/AnimationPlayer.play("Cylinder_001Action")
