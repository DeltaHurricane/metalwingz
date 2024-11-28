extends Node
class_name ShipMove 

var move: Dictionary

var m_n: String = ''

enum Moves {
	SMALL_CURVE_RIGHT,
	SMALL_CURVE_LEFT, CURVE_RIGHT,
	CURVE_LEFT,
	RETO,
	RETO_LONGO,
	STOP,
	CENTO80_RIGHT,
	CENTO80_LEFT,
	RAM,
	GRANADE
}

enum Dir {TORQUE, FORCE}
enum MoveType {SPECIAL, NORMAL}

static var reto: Texture2D = preload("res://assets/Arrows/green_up.png")
static var long_reto: Texture2D = preload("res://assets/Arrows/red_up.png")
static var small_right: Texture2D = preload("res://assets/Arrows/green_up_right.png")
static var small_left: Texture2D = preload("res://assets/Arrows/green_up_left.png")
static var right: Texture2D = preload("res://assets/Arrows/red_up_right.png")
static var left: Texture2D = preload("res://assets/Arrows/red_up_left.png")
static var back: Texture2D = preload("res://assets/Arrows/blue_back.png")
static var right_180: Texture2D = preload("res://assets/Arrows/red_180_right.png")
static var left_180: Texture2D = preload("res://assets/Arrows/red_180_left.png")
static var ram: Texture2D = preload("res://assets/Arrows/blue_forward.png")
static var granada: Texture2D = preload("res://assets/Explosions/Icons/Icon3.png")


static var min_force:int = 50
static var small_force:int = 100
static var medium_force:int = 200
static var strong_force:int = 300
static var rotate:int = 300

static var move_list: Dictionary = {
	ShipMove.Moves.SMALL_CURVE_RIGHT: {'time':0.5, 'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: small_force, 'sprite':small_right  },
	ShipMove.Moves.SMALL_CURVE_LEFT: {'time':0.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: small_force,'sprite':small_left },
	ShipMove.Moves.CURVE_RIGHT: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':right },
	ShipMove.Moves.CURVE_LEFT: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':left },
	ShipMove.Moves.RETO_LONGO: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: strong_force,'sprite':long_reto },
	ShipMove.Moves.RETO: {'time':1.0,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: small_force,'sprite':reto },
	ShipMove.Moves.STOP: {'time':1.0,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: -min_force,'sprite':back },
	ShipMove.Moves.CENTO80_RIGHT: {'time':1.5,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:475, ShipMove.Dir.FORCE: medium_force,'sprite':right_180 },
	ShipMove.Moves.CENTO80_LEFT: {'time':1.5,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:-475, ShipMove.Dir.FORCE: medium_force,'sprite':left_180 },
	ShipMove.Moves.RAM: {'time':2.5,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: strong_force,'sprite':ram, 'func':'shields' },
	ShipMove.Moves.GRANADE:{'time':2.0,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: 150,'sprite':granada, 'func':'granada' }
}

static func create(move_name: Moves) -> ShipMove:
	var instance: ShipMove = ShipMove.new()
	instance.move = move_list[move_name]
	instance.m_n = Moves.keys()[move_name]
	return instance
