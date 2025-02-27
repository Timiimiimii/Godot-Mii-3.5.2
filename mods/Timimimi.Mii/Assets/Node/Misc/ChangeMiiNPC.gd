extends CharacterBody3D

var CharinfoArrayMenu
@onready var MiiMod = get_node("/root/TimimimiMii")
var CharinfoPathPlayer = "user://Mii/charinfo/Player/Player.charinfo"
var CharinfoPathOther = "user://Mii/charinfo/Player/"
var CharinfoPathKnown = "user://Mii/charinfo/Friend/"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MiiSelectMenu
var MiiSelectGUI = preload("res://mods/Timimimi.Mii/Assets/Node/Menu/MiiSelect.tscn")
@onready var MiiHead = $MiiBody/Mii/Skeleton3D/BoneAttachment3D/player_face

# Called when the node enters the scene tree for the first time.
func _ready():
	MiiHead.MiiFileLoad("res://mods/Timimimi.Mii/Assets/Mii/Charinfo/Ming-Jie.charinfo")
	#MiiBody.get_child(0).get_child(0).get_child(1).get_surface_material(0).albedo_color = MiiHead.FavColour
	$MiiBody/Mii/Skeleton3D/Shirt.get_surface_override_material(0).albedo_color = MiiHead.FavColour
	$MiiBody/Mii/Skeleton3D/Pants.get_surface_override_material(0).albedo_color = Color("40464e")
	CharinfoArrayMenu = MiiMod.GrabMiiFiles(CharinfoPathOther)
	if (MiiSelectGUI):
		MiiSelectMenu = MiiSelectGUI.instantiate()
		MiiSelectMenu.hide()
		get_tree().root.add_child(MiiSelectMenu)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#res://mods/Timimimi.Mii/Assets/Mii/Charinfo/



func _on_Interactable__open():
	MiiSelectMenu.show()
