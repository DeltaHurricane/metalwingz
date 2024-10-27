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
	RAM
}

enum Dir {TORQUE, FORCE}
enum MoveType {SPECIAL, NORMAL}

static var reto: Resource = preload("res://assets/Arrows/green_up.png")
static var long_reto: Resource = preload("res://assets/Arrows/red_up.png")
static var small_right: Resource = preload("res://assets/Arrows/green_up_right.png")
static var small_left: Resource = preload("res://assets/Arrows/green_up_left.png")
static var right: Resource = preload("res://assets/Arrows/red_up_right.png")
static var left: Resource = preload("res://assets/Arrows/red_up_left.png")
static var back: Resource = preload("res://assets/Arrows/blue_back.png")
static var right_180: Resource = preload("res://assets/Arrows/red_180_right.png")
static var left_180: Resource = preload("res://assets/Arrows/red_180_left.png")


static var min_force:int = 50
static var small_force:int = 100
static var medium_force:int = 200
static var strong_force:int = 300
static var rotate:int = 300

static var move_list: Dictionary = {
	ShipMove.Moves.SMALL_CURVE_RIGHT: {'time':1.0, 'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: small_force, 'sprite':small_right  },
	ShipMove.Moves.SMALL_CURVE_LEFT: {'time':1.0,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: small_force,'sprite':small_left },
	ShipMove.Moves.CURVE_RIGHT: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':right },
	ShipMove.Moves.CURVE_LEFT: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':left },
	ShipMove.Moves.RETO_LONGO: {'time':1.5,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: strong_force,'sprite':long_reto },
	ShipMove.Moves.RETO: {'time':1.0,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: small_force,'sprite':reto },
	ShipMove.Moves.STOP: {'time':1.0,'type': ShipMove.MoveType.NORMAL,ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: -min_force,'sprite':back },
	ShipMove.Moves.CENTO80_RIGHT: {'time':1.5,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:475, ShipMove.Dir.FORCE: medium_force,'sprite':right_180 },
	ShipMove.Moves.CENTO80_LEFT: {'time':1.5,'type': ShipMove.MoveType.SPECIAL,ShipMove.Dir.TORQUE:-475, ShipMove.Dir.FORCE: medium_force,'sprite':left_180 }
}

static func create(move_name: Moves) -> ShipMove:
	var instance: ShipMove = ShipMove.new()
	instance.move = move_list[move_name]
	instance.m_n = Moves.keys()[move_name]
	return instance
