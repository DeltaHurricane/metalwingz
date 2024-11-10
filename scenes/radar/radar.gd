extends Area2D

class_name Radar

var width: float = 0
var height: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent: Ship = get_parent()
	height = parent.radarHeight
	width = parent.radarWidth
	scale = Vector2(height,width)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func disable_radar(disabledTime:float): 
	$DisabledRadar.stop()
	$DisabledRadar.start(disabledTime)
	scale = Vector2(0,0)
	hide()
	$RadarColision.set_deferred("disabled", true) 

	
func _on_disabled_radar_timeout() -> void:
	scale = Vector2(0,0)
	show()
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(height,width),0.9)
	$RadarColision.set_deferred("disabled", false)
	
