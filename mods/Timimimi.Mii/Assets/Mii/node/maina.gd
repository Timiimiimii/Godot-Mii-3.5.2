extends Node
const ID = "Timimimi.Mii"
const MiiHead = preload("res://mods/Timimimi.Mii/Assets/Mii/node/mii_head.tscn")
var player
var latest_scene_name = ""
#onready var Lure = get_node("/root/SulayreLure")
var CharinfoPathPlayer = "user://Mii/charinfo/Player/Player.charinfo"
var CharinfoPathOther = "user://Mii/charinfo/Player/"
var CharinfoPathKnown = "user://Mii/charinfo/Friend/"
var DummyPlayer = "res://mods/Timimimi.Mii/Assets/Mii/Charinfo/DefaultM.charinfo"
var DummyMii = "res://mods/Timimimi.Mii/Assets/Mii/Charinfo/"
var InjectedMiiButton = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PlayerHUD
var PlayerAPI
var CharinfoArray = []
var CatHeadMesh
var DogHeadMesh
func init_player(player: Actor):
	# example:
	if player.name == "player":
		CatHeadMesh = player.get_node("body/player_body/Armature/Skeleton/head_cat").mesh.get_faces()
		DogHeadMesh = player.get_node("body/player_body/Armature/Skeleton/head_dog").mesh.get_faces()
	#print(PlayerAPI.get_player_name(player))
	MiiHeadAssign(player)
	#HideOGHead(player)
	return
				#print(n.get_mesh()) 
				#if n.resource_path == "res://Assets/Models/Cosmetics/dog_head.tres" or n.resource_path == "res://Assets/Models/Cosmetics/cat_head.tres":
				#	n.queue_free()
				#n.queue_free()
				#print(n.mesh.get_faces())
			#print("cat head")
			#print(player.get_node("body/player_body/Armature/Skeleton/head_cat").mesh.get_faces())
			#print("dog head")
			#print(player.get_node("body/player_body/Armature/Skeleton/head_dog").mesh.get_faces())
		#player.species.scale = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	#Lure.assign_cosmetic_mesh(ID, "species_cat", "species_cat", "mod://Assets/Dummy.tres")
	#Lure.assign_cosmetic_mesh(ID, "species_dog", "species_dog", "mod://Assets/Dummy.tres")
	#initialize()
	#PlayerHUD = get_node_or_null("/root/playerhud")
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", self, "init_player")
	#GrabMiiFiles(CharinfoPathOther)
	
	
func MiiHeadAssign(player: Actor):
	var file = File.new()
	#GrabMiiFiles(CharinfoPathOther)
	var MiiInstance = MiiHead.instance()
	var playerSteamID = PlayerAPI.get_player_steamid(player)
	var CharInfoRandNo
	var CharInfoSelectedNo
	if CharinfoArray.empty() == false:
		CharInfoRandNo = randi()%CharinfoArray.size()
		
	if player.name == "player":
		player.get_node("body/player_body/Armature/Skeleton/face/player_face").queue_free()
		player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiInstance)
		player.face = MiiInstance.get_node(".")
		#MiiInstance.name = 'player_face'
		MiiInstance.PlayerNode = player.get_node(".")
		MiiInstance.CharData = player.cosmetic_data
		if file.file_exists(CharinfoPathPlayer) == true:
			MiiInstance.MiiFileLoad(CharinfoPathPlayer)
		elif file.file_exists(CharinfoPathPlayer) == false:
			if CharinfoArray.empty()==false:
				print("player file no exists")
				MiiInstance.MiiFileLoad(str(CharinfoPathOther+CharinfoArray[CharInfoSelectedNo]))
				#CalcArmatureScaleTest(player,MiiInstance.MiiHeight,MiiInstance.MiiWeight)
				#player.get_node("Viewport/player_label").label = str(CharinfoArray[1]).replace('.charinfo', '')
				CharinfoArray.remove(CharInfoSelectedNo)
			else:
				MiiInstance.PlayerNode = player.get_node(".")
				GrabMiiFiles(CharinfoPathOther)
				MiiHeadAssign(player)
			#MiiInstance.MiiFileLoad(DummyPlayer)
		MiiInstance._MiiToneBody()
		#CalcArmatureScaleTest(player,MiiInstance.MiiHeight,MiiInstance.MiiWeight)
		if MiiInstance._Amiimal_Check() == true:
			MiiInstance._Amiimal_Features(null)
		#player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiHead.instance()).MiiFileLoad(CharinfoPathPlayer)
	elif player.name.begins_with("@player@")== true:
		#CharInfoSelectedNo = int(str(CharInfoRandNo))
		player.get_node("body/player_body/Armature/Skeleton/face/player_face").queue_free()
		player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiInstance)
		player.face = MiiInstance.get_node(".")
		MiiInstance.PlayerNode = player.get_node(".")
		MiiInstance.CharData = player.cosmetic_data
		MiiInstance._MiiToneBody()
		print(str(CharinfoPathKnown+str(playerSteamID)+".charinfo"))
		if file.file_exists(str(CharinfoPathKnown+str(playerSteamID)+".charinfo")) == true:
			print("friend file exists")
			MiiInstance.MiiFileLoad(str(CharinfoPathKnown+str(playerSteamID)+".charinfo"))
			#CalcArmatureScaleTest(player,MiiInstance.MiiHeight,MiiInstance.MiiWeight)
		elif CharinfoArray.empty()==false:
			print("friend file no exists")
			MiiInstance.MiiFileLoad(str(CharinfoPathOther+CharinfoArray[CharInfoRandNo]))
			#CalcArmatureScaleTest(player,MiiInstance.MiiHeight,MiiInstance.MiiWeight)
			#player.get_node("Viewport/player_label").label = str(CharinfoArray[1]).replace('.charinfo', '')
			CharinfoArray.remove(CharInfoRandNo)
		else:
			MiiInstance.PlayerNode = player.get_node(".")
			GrabMiiFiles(DummyMii)
			MiiHeadAssign(player)
			pass
		MiiInstance._MiiToneBody()
		if MiiInstance._Amiimal_Check() == true:
			MiiInstance._Amiimal_Features(null)
			#player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiHead.instance()).MiiFileLoad(str(CharinfoPathOther+CharinfoArray[randi()%CharinfoArray.size()]))
		
func HideOGHead(player: Actor):
	if player != null:
		for n in player.get_node_or_null("body/player_body/Armature/Skeleton/").get_children():
			if n is MeshInstance and n.mesh != null and player != null:
				var MeshFace = n.mesh.get_faces()
				if MeshFace == CatHeadMesh:
					n.visible = false
				elif MeshFace == DogHeadMesh:
					n.visible = false
				else:
					pass
func initialize():
	if !in_lobby():
		print("In main menu or loading menu. Mii Head will not initialize.")
		return
	player = get_player_node()
	latest_scene_name = get_tree().current_scene.name
	if player:
		#load_player_size()
		print("Mii Head initialized with player instance: ", player.name)
	else:
		print("No player instance found yet. Waiting...")

func in_lobby():
	var current_scene_name = get_tree().current_scene.name
	return current_scene_name != "main_menu" and current_scene_name != "loading_menu" and current_scene_name != "splash"

func in_main_menu():
	var current_scene_name = get_tree().current_scene.name
	return current_scene_name == "main_menu" and current_scene_name != "loading_menu"
	
func get_player_node():
	return get_tree().current_scene.get_node_or_null("Viewport/main/entities/player")

func GrabMiiFiles(path):

	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true,false)
	while true:
		var file = dir.get_next()
		if file == "":
			GrabMiiFiles("res://mods/Timimimi.Mii/Assets/Mii/Charinfo")
			break
		elif not file.begins_with("."):
			CharinfoArray.append(file)
			#print(CharinfoArray)
			CharinfoArray.erase('Player.charinfo')
			if CharinfoArray.empty() == true:
				GrabMiiFiles("res://mods/Timimimi.Mii/Assets/Mii/Charinfo")
	return CharinfoArray

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if in_lobby() == true:
		#PlayerHUD = get_node_or_null("/root/playerhud")
	if PlayerAPI.players and in_lobby() == true:
		if Engine.get_idle_frames() % 10 == 0:
			for player in PlayerAPI.players:
				HideOGHead(player)
				#spamDatCommand(player)
				
	elif !in_lobby():
		pass
	if InjectedMiiButton == false and in_main_menu() == true:
		add_maker_button()
		#print("In loading/main menu, won't inject Miis")
	#print(CharinfoArray)
	#print(str(CharinfoPathOther+CharinfoArray[randi()%CharinfoArray.size()]))
	#var playerArray = get_tree().get_nodes_in_group("player")
	#for play in playerArray:
	#print(playerArray)
		#HideOGHead(play)
	#if is_cosmetic_menu_active() == true:
		#pass

func add_maker_button():
	InjectedMiiButton = true
	var MenuBox = get_tree().current_scene.get_node_or_null("VBoxContainer")
	var MakerButton = preload("res://mods/Timimimi.Mii/Assets/Node/Misc/mii_maker_button.tscn")
	var ButtonInstance = MakerButton.instance()
	MenuBox.add_child(ButtonInstance)
	#MenuBox.move_child(ButtonInstance,2)
func is_cosmetic_menu_active() -> bool:
	var playerhud = get_tree().get_root().get_node_or_null("playerhud")
	if playerhud.menu ==2:
		return true
	else:
		return false

func spamDatCommand(player):
	var MiiHead
	if is_instance_valid(MiiHead) == false:
		MiiHead = null
	if player != null:
		MiiHead = player.get_node("body/player_body/Armature/Skeleton/face").get_child(0)
		if is_instance_valid(MiiHead) == true:
			if MiiHead.has_method("_MiiToneBody") == true:
				MiiHead._MiiToneBody()
		
func CalcArmatureScaleTest(player, MiiHeight, MiiWeight):
	var scale = Vector3(1,1,1)
	scale.x = (MiiWeight * (MiiHeight * 0.003671875 + 0.4)) / 128.0 + MiiHeight * 0.001796875 + 0.4;
	scale.y = MiiHeight * 0.006015625 + 0.5;
	scale.z = scale.x
	var HeadBoneTransform = player.get_node_or_null("body/player_body/Armature/Skeleton").get_bone_rest(11).scaled(Vector3(1,1,1)/scale)
	var HeadScale
	var HeadBoneTransformP = player.get_node_or_null("body/player_body/Armature/Skeleton").get_bone_pose(11).scaled(Vector3(1,1,1)/scale)

	#player.get_node_or_null("body/player_body/Armature/Skeleton").scale = scale
	#pelvis
	#player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(0,CalcBoneScaleR(player,scale,0))
	
	#arml
	player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(3,CalcBoneScaleR(player,scale,3))

	#armr
	player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(7,CalcBoneScaleR(player,scale,7))
	#legl
	player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(13,CalcBoneScaleR(player,scale,13))
	#legr
	player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(16,CalcBoneScaleR(player,scale,16))
	
#	player.get_node_or_null("body/player_body/Armature/Skeleton").set_bone_rest(11,HeadBoneTransform)
	
func CalcBoneScaleR(player,scale,bone):
	var BoneTransform = player.get_node_or_null("body/player_body/Armature/Skeleton").get_bone_rest(int(bone))
	BoneTransform = BoneTransform.scaled(scale)
	return BoneTransform
func CalcBoneScaleP(player,scale,bone):
	var BoneTransform = player.get_node_or_null("body/player_body/Armature/Skeleton").get_bone_pose(int(bone)).scaled(scale)
	return BoneTransform

func AddMiiToInv():
	var InvBut = load("res://mods/Timimimi.Mii/Assets/Node/Misc/mii_inv_button.tscn").instance()
	PlayerHUD.get_node_or_null("main/menu/tabs/outfit/HBoxContainer").add_child(InvBut)
	
func NewPlayerMii(MiiFile):
	var MiiHead = get_player_node().get_node_or_null("body/player_body/Armature/Skeleton/face").get_child(0)
	MiiHead.MiiFileLoad(str(CharinfoPathOther)+str(MiiFile))

func _on_mii_cont_ready():
	var MiiIcon = $Viewport/MiiHead
	for Mii in CharinfoArray:
		MiiIcon.MiiFileLoad()
		
