class_name ShipMove extends Node

var move: Dictionary
var m_n: String = ''

enum Moves {SMALL_CURVE_RIGHT, SMALL_CURVE_LEFT, CURVE_RIGHT, CURVE_LEFT, RETO, RETO_LONGO, STOP}
enum Dir {TORQUE, FORCE}

static var small_force:int = 100
static var medium_force:int = 200
static var strong_force:int = 300

static var move_list = {
	ShipMove.Moves.SMALL_CURVE_RIGHT: {ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: small_force },
	ShipMove.Moves.SMALL_CURVE_LEFT: {ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: small_force },
	ShipMove.Moves.CURVE_RIGHT: {ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: medium_force },
	ShipMove.Moves.CURVE_LEFT: {ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: medium_force },
	ShipMove.Moves.RETO_LONGO: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: strong_force },
	ShipMove.Moves.RETO: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: small_force },
	ShipMove.Moves.STOP: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: 0 }
}

static func create(move_name: Moves) -> ShipMove:
	var instance: ShipMove = ShipMove.new()
	instance.move = move_list[move_name]
	instance.m_n = Moves.keys()[move_name]
	return instance
