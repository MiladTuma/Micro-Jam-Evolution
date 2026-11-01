extends Node2D

@onready var mobile_ui = $MobileUI
@onready var textbox_ui = $Textbox
func _ready() -> void:
	
	if GameSettings.is_mobile:
		mobile_ui.visible = true
		textbox_ui.visible = false
	else:
		
		mobile_ui.visible = false
