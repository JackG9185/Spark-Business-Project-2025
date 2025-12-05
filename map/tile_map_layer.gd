extends TileMapLayer
var color = 0
var switched = 0
func shift_color():
	color += 1
	switched += 60
	if color % 5 == 0:
		print("SHIFT")
		material.set_shader_parameter("shift_amount", switched%360)
