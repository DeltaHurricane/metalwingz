extends Control

@export var action_items: Array[String] = ['move_left', 'move_right','move_up', 'move_down', 'fast', 'spec']
var currentPlayerIndex: int = 0:
	set(newNumber):
		currentPlayerIndex = newNumber
		%CurrantePlayerLabel.text = "Player: %s" % str(currentPlayerIndex)
		create_action_remap_items()

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var buttons_v_box = %ButtonsVBox
@onready var control_grid_container = %PlayerControlContainer
@onready var player_index_container = %ChangeCurrentIndexContainer
@onready var main_menu_button = %MainMenuButton


func _ready():
	create_action_remap_items()
	Globals.changePlayerCount.connect(changeMaxPlayers)
	%CurrantePlayerLabel.text = "Player: %s" % str(currentPlayerIndex)
	$MarginContainer/ButtonsVBox/SettingsGridContainer/MusicSlider.grab_focus()
	
func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()


func _on_visibility_changed():
	if visible:
		focus_button()



func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func create_action_remap_items() -> void:
	for n in control_grid_container.get_children():
		control_grid_container.remove_child(n)
		n.queue_free()
	var previous_item = player_index_container.get_child(player_index_container.get_child_count() - 1)
	for index in range(action_items.size()):
		var action = action_items[index]
		var label = Label.new()
		label.text = action
		control_grid_container.add_child(label)
		if(not InputMap.has_action(action + "%s" %  str(currentPlayerIndex))):
			InputMap.add_action(action + "%s" %  str(currentPlayerIndex))
		
		
		var button = RemapButton.new()
		button.action = action + "%s" %  str(currentPlayerIndex)

		button.focus_neighbor_top = previous_item.get_path()
		previous_item.focus_neighbor_bottom = button.get_path()
		if index == action_items.size() - 1:
			main_menu_button.focus_neighbor_top = button.get_path()
			button.focus_neighbor_bottom = main_menu_button.get_path()
		previous_item = button
		control_grid_container.add_child(button)
		
	
func changeMaxPlayers(): 
	if(currentPlayerIndex > Globals.player_number - 1):
		currentPlayerIndex = Globals.player_number

func _on_index_down_pressed() -> void:
	if(currentPlayerIndex  > 0):
		currentPlayerIndex -= 1 
		


func _on_index_up_pressed() -> void:
	if(currentPlayerIndex < (Globals.player_number - 1)):
		currentPlayerIndex += 1 
