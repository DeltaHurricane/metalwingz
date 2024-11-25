extends Button
class_name RemapButton

@export var action: String


func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"
	
	
func _ready():
	set_process_unhandled_input(false)
	update_key_text()
	
	
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "... Awaiting Input ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		
		
func _unhandled_input(event) -> void:
	Globals.inputHelper._input(event)
	if  (event is InputEventJoypadMotion and abs(event.axis_value) < 0.7):
			return
	#Globals.inputHelper.set_keyboard_or_joypad_input_for_action(action, event)
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	button_pressed = false
	
	
func update_key_text():
	var actionArray = InputMap.action_get_events(action)
	if(actionArray.size() > 0):
		text = "%s" % actionArray[0].as_text()
	else:
		text = "No key binded"
