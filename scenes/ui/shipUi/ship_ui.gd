extends Node2D
class_name Ship_UI


var ship_id: int = 0:
	set(new_id):
		ship_id = new_id
		$Player.text = 'P'+str(new_id)
var max_hp: float = 0


var current_hp: String = '100%'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AutoloadedSignals.change_ship_hp.connect(setHp)


func setHp(player_id:int,hp:float) -> void:
	var curr_hp = round(hp*100.0/max_hp)
	if(curr_hp<0):
		curr_hp = 0
	if(player_id == ship_id):
		current_hp = str(curr_hp)+'%'
		$HpLabel.text = current_hp
		$Border/HpBarMask/HpBar.position = Vector2(-(100-curr_hp)*0.3,0)

func setMoves(move: ShipMove) -> void:
	var moves = $MovementContainer/Polygon2D/Movement
	if (move is ShipMove):
		var texture: Texture2D = move.move.sprite
		var tHeight = texture.get_height()
		var tWidth = texture.get_width()
		moves.texture = texture
		moves.scale = Vector2(14.0/tWidth,14.0/tHeight)
	else:
		moves.texture = null
	
	
func playTimer(moveTimer:float):
	$MoveTimer.play(moveTimer)
