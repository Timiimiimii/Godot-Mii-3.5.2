extends Control
var PlayerAPI
var MiiButton = preload("res://mods/Timimimi.Mii/Assets/Node/Menu/mii_select_button.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var MiiMod = get_node("/root/TimimimiMii")
var MiiHead = preload("res://mods/Timimimi.Mii/Assets/Mii/node/mii_head_plus.tscn")
var MiiList
var PlayerMiiHead
@onready var MiiCont = $ScrollContainer/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", Callable(self, "init_player"))
	MiiList = MiiMod.GrabMiiFiles(MiiMod.CharinfoPathOther)
	#print(MiiList)
	#init_miiButton()
	$FileDialog.current_dir = str(MiiMod.CharinfoPathOther)
	#$FileDialog.chec
func init_player(player: Actor):
	if player.name == "player":
		PlayerMiiHead = player.get_node("body/player_body/Armature/Skeleton3D/face").get_child(0)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	visible = true
	$FileDialog.popup()
func hide(): visible = false

func init_miiButton():
	print(MiiList)
	for Mii in MiiList:
		var MiiInstance = MiiHead.instantiate()
		var ButInstance = MiiButton.instantiate()
		MiiCont.add_child(MiiButton.instantiate())
		#ButInstance.get_child(2).get_child(0).connect("_MiiSelected", self, "_SetupPlayerMii")
		#yield(get_tree().create_timer(3),"timeout")
		#print(ButInstance.get_child(2).get_child(0).name)
		#yield(ButInstance.get_child(2).get_child(0), "MiiReady")
		#print(MiiList[Mii])
		#print("ok we got past yield")
		ButInstance.get_child(2).add_child(MiiInstance)
		
		#ButInstance.get_child(2).get_child(0).MiiFileLoad(str(MiiMod.CharinfoPathOther+Mii))
		ButInstance.get_child(1).get_child(2).body = ""
		ButInstance.get_child(1).get_child(2).header = str(Mii).replacen(".charinfo","")
		#ButInstance._UpdateMii(str(MiiMod.CharinfoPathOther+Mii))
		ButInstance.connect("_MiiSelected", Callable(self, "_EditPlayerMii"))
		#_SetupMiiBut(ButInstance, MiiList[Mii])
		#MiiInstance.MiiFileLoad(str(MiiMod.CharinfoPathOther+Mii))
func _EditPlayerMii(Mii):
	MiiMod.PlayerMiiHead.MiiFileLoad(str(Mii))


func _CloseMenu():
	hide()

func _SetupMiiBut(ButInstance, Mii):
		ButInstance.get_child(2).get_child(0).MiiFileLoad(str(MiiMod.CharinfoPathOther+Mii))
		ButInstance.get_child(1).get_child(2).body = ""
		ButInstance.get_child(1).get_child(2).header = str(Mii).replacen(".charinfo","")
		#ButInstance._UpdateMii(str(MiiMod.CharinfoPathOther+Mii))
		ButInstance.connect("_MiiSelected", Callable(self, "_EditPlayerMii"))


func _on_FileDialog_file_selected(path):
	if str(path).ends_with(".charinfo"):
		_EditPlayerMii(path)
		_CloseMenu()
	else:
		pass


func _on_FileDialog_popup_hide():
	_CloseMenu()
