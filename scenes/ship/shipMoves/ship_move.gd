class_name ShipMove extends Node

var move: Dictionary
var m_n: String = ''

enum Moves {SMALL_CURVE_RIGHT, SMALL_CURVE_LEFT, CURVE_RIGHT, CURVE_LEFT, RETO, RETO_LONGO, STOP}
enum Dir {TORQUE, FORCE}

static var reto = preload("res://assets/Arrows/green_up.png")
static var long_reto = preload("res://assets/Arrows/red_up.png")
static var small_right = preload("res://assets/Arrows/green_up_right.png")
static var small_left = preload("res://assets/Arrows/green_up_left.png")
static var right = preload("res://assets/Arrows/red_up_right.png")
static var left = preload("res://assets/Arrows/red_up_left.png")
static var back = preload("res://assets/Arrows/blue_back.png")


static var min_force:int = 50
static var small_force:int = 100
static var medium_force:int = 200
static var strong_force:int = 300

static var move_list: Dictionary = {
	ShipMove.Moves.SMALL_CURVE_RIGHT: {ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: small_force, 'sprite':small_right  },
	ShipMove.Moves.SMALL_CURVE_LEFT: {ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: small_force,'sprite':small_left },
	ShipMove.Moves.CURVE_RIGHT: {ShipMove.Dir.TORQUE:medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':right },
	ShipMove.Moves.CURVE_LEFT: {ShipMove.Dir.TORQUE:-medium_force, ShipMove.Dir.FORCE: medium_force,'sprite':left },
	ShipMove.Moves.RETO_LONGO: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: strong_force,'sprite':long_reto },
	ShipMove.Moves.RETO: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: small_force,'sprite':reto },
	ShipMove.Moves.STOP: {ShipMove.Dir.TORQUE:0, ShipMove.Dir.FORCE: -min_force,'sprite':back }
}

static func create(move_name: Moves) -> ShipMove:
	var instance: ShipMove = ShipMove.new()
	instance.move = move_list[move_name]
	instance.m_n = Moves.keys()[move_name]
	return instance
