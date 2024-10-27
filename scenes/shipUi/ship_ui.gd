extends Node2D
class_name Ship_UI

var Movement_scene = preload("res://scenes/shipUi/movement.tscn")

var ship_id: int = 0:
	set(new_id):
		ship_id = new_id
		$Player.text = 'P'+str(new_id)
var max_hp: float = 0
var max_moves: int = 0:
	set(new_max):
		max_moves = new_max
		for i in range(new_max):
			var new_movement = Movement_scene.instantiate()
			new_movement.position = Vector2(32 * i + 12,16)
			$MovementContainer.add_child(new_movement)

var current_hp: String = '100%'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AutoloadedSignals.change_ship_hp.connect(setHp)


func setHp(player_id:int,hp:float) -> void:
	var curr_hp = round(hp*100.0/max_hp)
	if(player_id == ship_id):
		current_hp = str(curr_hp)+'%'
		$HpLabel.text = current_hp
		$Border/HpBarMask/HpBar.position = Vector2(-(100-curr_hp)*0.3,0)

func setMoves(moveList: Array[ShipMove]) -> void:
	var moves = $MovementContainer.get_children()

	for i in range(moves.size()):
		if (moveList.size() > i):
			moves[i].texture = moveList[i].move.sprite
		else:
			moves[i].texture = null
	
	
func playTimer(moveTimer:float):
	$MoveTimer.play(moveTimer)
