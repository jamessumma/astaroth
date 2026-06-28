@tool
extends MeshInstance3D

@export var corners: Array[Vector3] = [
	Vector3(-1, -1, -1), Vector3( 1, -1, -1),
	Vector3( 1,  1, -1), Vector3(-1,  1, -1),
	Vector3(-1, -1,  1), Vector3( 1, -1,  1),
	Vector3( 1,  1,  1), Vector3(-1,  1,  1),
]:
	set(value):
		corners = value
		_rebuild()

func _ready():
	_rebuild()

func _rebuild():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var triangles = [
		2,0,1, 3,0,2,
		5,4,6, 6,4,7,
		4,0,7, 7,0,3,
		2,1,6, 6,1,5,
		1,0,5, 5,0,4,
		7,3,6, 6,3,2,
	]

	for i in triangles:
		st.add_vertex(corners[i])

	st.generate_normals()
	mesh = st.commit()
