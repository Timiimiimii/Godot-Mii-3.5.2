extends Control
#onready var MiiHead = get_node_or_null("Viewport/player_face")
#var MiiPath
export  var tab_num = 0
export  var y_offset = 10
export  var x_offset = 0
export (Texture) var image
export  var header = ""
export  var desc = ""
export var butType = "cat"
export var MiiFile = "Mii"
var hovered = false
var highlighted = false
export var feat = "Head"
onready var shadow = $shadow
var extra_x
var extra_y
signal _pressed
signal _featUpdate
signal _featUpdate2
signal _HairUpdate
signal _Minipressed
signal _MiiSelected
func _process(delta):
	var alt_color = Color(0.8, 0.8, 0.8) if not hovered else Color(0.9, 0.9, 0.9)
	if butType != "pos":
		modulate = alt_color if not highlighted else Color(1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0,1.0,1.0)
	if butType == "cat":
		extra_y = 0 if not highlighted else - 8
		extra_x=0
	if butType == "mii":
		extra_y = 0 if not highlighted else - 8
		extra_x=0
	if butType == "feat":
		extra_y = 0 if not highlighted else - 8
		extra_x=0
	elif butType == "catMini":
		extra_y=0
		extra_x = 0 if not highlighted else - 8
	elif butType == "pos":
		extra_y = 0 if not highlighted else - 8
		extra_x=0
	$TextureButton.rect_position.y = lerp($TextureButton.rect_position.y, y_offset + extra_y, 0.2)
	$TextureButton.rect_position.x = lerp($TextureButton.rect_position.x, x_offset + extra_x, 0.2)
	$TextureButton/TextureRect.rect_position.y = - 3
	
	$TextureButton.margin_bottom = 61 + y_offset + extra_y
	$TextureButton.margin_top = 0 + y_offset + extra_y

func _update(current_slot):
	if butType != "pos":
		highlighted = current_slot == tab_num
	else:
		highlighted = false
	$TextureButton/TextureRect.visible = highlighted
	$TextureButton / TooltipNode.header = header
	$TextureButton / TooltipNode.body = desc
	$TextureButton/TextureRect2.texture = image
	$shadow.rect_position.y = y_offset + 4

func _on_TextureButton_pressed():
	#print("pressed")
	if butType == "cat":
		emit_signal("_pressed", tab_num)
	if butType == "catMini":
		emit_signal("_Minipressed", tab_num, feat)
	if butType == "feat":
		emit_signal("_featUpdate", tab_num, feat)
		emit_signal("_featUpdate2", tab_num, feat)
	if butType == "mii":
		emit_signal("_MiiSelected", MiiFile, feat)
	if butType == "pos":
		emit_signal("_featUpdate", tab_num, feat)
		emit_signal("_featUpdate2", tab_num, feat)
func _on_TextureButton_mouse_entered(): hovered = true
func _on_TextureButton_mouse_exited(): hovered = false

func _ready():
	#MiiHead =  $Viewport/player_face
	connect("mouse_entered", GlobalAudio, "_play_sound", ["swish"])
	if has_signal("button_down"): connect("button_down", GlobalAudio, "_play_sound", ["button_down"])
	if has_signal("button_up"): connect("button_up", GlobalAudio, "_play_sound", ["button_up"])
	#_UpdateMii(MiiPath)

func _on_TextureButton_button_down():
	$TextureButton/TextureRect.visible = true
	
func _UpdateMii(Mii):
	#MiiHead.MiiFileLoad(Mii)
	pass
func _UpdatePlayerMii(Mii, PlayerHead):
	pass
