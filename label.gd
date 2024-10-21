extends Label





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var s = ''
	for i: ShipMove in $"../Ship".move_list:
		s += str(i.m_n) + '\n'
	text = s 
