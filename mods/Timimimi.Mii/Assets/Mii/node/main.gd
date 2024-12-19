extends Node
const ID = "Timimimi.Mii"
const MiiHead = preload("res://mods/Timimimi.Mii/Assets/Mii/node/mii_head.tscn")
var player
var latest_scene_name = ""

var CharinfoPathPlayer = "user://Mii/charinfo/Player/Player.charinfo"
var CharinfoPathOther = "user://Mii/charinfo/Player/"
var CharinfoPathKnown = "user://Mii/charinfo/Friend/"
var InjectedMiiButton = false



var PlayerAPI
var CharinfoArray = []
var CatHeadMesh
var DogHeadMesh
func init_player(player: Actor):
	
	if player.name == "player":
		CatHeadMesh = player.get_node("body/player_body/Armature/Skeleton/head_cat").mesh.get_faces()
		DogHeadMesh = player.get_node("body/player_body/Armature/Skeleton/head_dog").mesh.get_faces()
	print(PlayerAPI.get_player_name(player))
	MiiHeadAssign(player)
	
	return 
				
				
				
				
				
			
			
			
			
		

func _ready():
	
	
	
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", self, "init_player")
	GrabMiiFiles(CharinfoPathOther)
	
	
func MiiHeadAssign(player: Actor):
	#GrabMiiFiles(CharinfoPathOther)
	var MiiInstance = MiiHead.instance()
	var playerSteamID = PlayerAPI.get_player_steamid()
	var CharInfoRandNo = randi() % CharinfoArray.size()
	var CharInfoSelectedNo
	if player.name == "player":
		player.get_node("body/player_body/Armature/Skeleton/face/player_face").queue_free()
		player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiInstance)
		player.face = MiiInstance.get_node(".")
		MiiInstance.PlayerNode = player.get_node(".")
		MiiInstance.CharData = player.cosmetic_data
		MiiInstance.MiiFileLoad(CharinfoPathPlayer)
		MiiInstance._MiiToneBody()
		if MiiInstance._Amiimal_Check() == true:
			MiiInstance._Amiimal_Features(null)
		
	elif player.name.begins_with("@player@") == true:
		if CharinfoArray.empty() == false:
			CharInfoSelectedNo = int(CharInfoRandNo)
			player.get_node("body/player_body/Armature/Skeleton/face/player_face").queue_free()
			player.get_node("body/player_body/Armature/Skeleton/face").add_child(MiiInstance)
			player.face = MiiInstance.get_node(".")
			MiiInstance.PlayerNode = player.get_node(".")
			MiiInstance.CharData = player.cosmetic_data
			if ResourceLoader.exists(str(CharinfoPathKnown + playerSteamID + ".charinfo")):
				MiiInstance.MiiFileLoad(str(CharinfoPathKnown + playerSteamID + ".charinfo"))
			else :
				MiiInstance.MiiFileLoad(str(CharinfoPathOther + CharinfoArray[CharInfoSelectedNo]))
				
				CharinfoArray.erase(CharInfoSelectedNo)
			MiiInstance._MiiToneBody()
			if MiiInstance._Amiimal_Check() == true:
				MiiInstance._Amiimal_Features(null)
			
		else :
			MiiInstance.PlayerNode = player.get_node(".")
			GrabMiiFiles(CharinfoPathOther)
			MiiHeadAssign(player)
func HideOGHead(player: Actor):
	if player != null:
		for n in player.get_node_or_null("body/player_body/Armature/Skeleton/").get_children():
			if n is MeshInstance and n.mesh != null and player != null:
				var MeshFace = n.mesh.get_faces()
				if MeshFace == CatHeadMesh:
					n.visible = false
				elif MeshFace == DogHeadMesh:
					n.visible = false
				else :
					pass
func initialize():
	if not in_lobby():
		print("In main menu or loading menu. Mii Head will not initialize.")
		return 
	player = get_player_node()
	latest_scene_name = get_tree().current_scene.name
	if player:
		
		print("Mii Head initialized with player instance: ", player.name)
	else :
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
	dir.list_dir_begin(true, false)
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			CharinfoArray.append(file)
			
			CharinfoArray.erase("Player.charinfo")
			if CharinfoArray.empty() == true:
				GrabMiiFiles("res://mods/Timimimi.Mii/Assets/Mii/Charinfo")
	return CharinfoArray


func _process(delta):
	if PlayerAPI.players and in_lobby() == true:
		if Engine.get_idle_frames() % 10 == 0:
			for player in PlayerAPI.players:
				HideOGHead(player)
				spamDatCommand(player)
	elif not in_lobby():
		pass
	if InjectedMiiButton == false and in_main_menu() == true:
		add_maker_button()
		
	
	
	
	
	
		
	
		

func add_maker_button():
	InjectedMiiButton = true
	var MenuBox = get_tree().current_scene.get_node_or_null("VBoxContainer")
	var MakerButton = preload("res://mods/Timimimi.Mii/Assets/Node/Misc/mii_maker_button.tscn")
	var ButtonInstance = MakerButton.instance()
	MenuBox.add_child(ButtonInstance)
	
func is_cosmetic_menu_active()->bool:
	var playerhud = get_tree().get_root().get_node_or_null("playerhud")
	if playerhud.menu == 2:
		return true
	else :
		return false

func spamDatCommand(player):
	var MiiHead
	if player != null:
		if is_instance_valid(MiiHead):
			MiiHead = player.get_node("body/player_body/Armature/Skeleton/face").get_child(0)
			if MiiHead.has_method("_MiiToneBody") == true:
				MiiHead._MiiToneBody()
		


