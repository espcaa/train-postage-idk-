extends Node3D

@export var chunk_scene: PackedScene
@export var speed = 20.0
@export var chunk_length = 73.0

var active_chunks = []


func _ready():
	for i in range(5):
		spawn_chunk(i * chunk_length)


func _process(delta):
	for chunk in active_chunks:
		chunk.position.z += speed * delta

		if chunk.position.z > chunk_length:
			reset_chunk(chunk)


func spawn_chunk(z_pos):
	var chunk = chunk_scene.instantiate()
	chunk.position.z = -z_pos
	add_child(chunk)
	active_chunks.append(chunk)


func reset_chunk(chunk):
	chunk.position.z -= chunk_length * active_chunks.size()
