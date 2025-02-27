extends Control
var current_tab
@onready var buttons = $UIContainer/MakerHUD/Category/buttons
@onready var tabs = $UIContainer/MakerHUD/Category/tabs
@onready var minitabs = $UIContainer/MakerHUD/Category/minitab
var MiiCamRot = false
var MiiCamRotating = false
var MiiCamLarge = false
var prevMosPos
var nextMosPos
var Event
var MosSpeed
@onready var MiiSkele = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/MiiBody/Mii/Skeleton3D
@onready var MiiBody = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/MiiBody
@onready var MiiCamera = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/CameraBob
@onready var MiiFaceCamH = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/CameraHori
@onready var MiiFaceCamV = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/CameraHori/CameraVert
@onready var MiiFaceCam = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/player_face/CameraHori/CameraVert/MiiFaceCam
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var DefaultM = "res://mods/Timimimi.Mii/Assets/Mii/Charinfo/DefaultM.charinfo"
@onready var MiiHead = $SubViewportContainer/SubViewport/MiiScene/MiiGrp/MiiBody/Mii/Skeleton3D/BoneAttachment3D/player_face

# Called when the node enters the scene tree for the first time.
func _ready():
	#MiiCamera.play("CameraBob")
	_UpdateMiiBody()
	MiiCamera.stop()
	$SubViewportContainer/SubViewport/MiiScene/MiiGrp/MiiBody/AnimationPlayer.play("Wait")
	#MiiHead.canBlink = false
	MiiHead.MiiFileLoad(DefaultM)
	_change_tab(0)
	_change_tab_mini(0,"Faceline")
	for child in buttons.get_children(): child.connect("_pressed", Callable(self, "_change_tab"))
	for child in tabs.get_children(): 
		for child2 in child.get_child(0).get_child(0).get_children():
			child2.connect("_featUpdate", Callable(self, "_UpdateMii"))
			child2.connect("_featUpdate2", Callable(self, "_change_feat"))
	for child in minitabs.get_children(): 
		for child2 in child.get_children():
			child2.connect("_Minipressed", Callable(self, "_change_tab_mini"))
			child2.connect("_featUpdate", Callable(self, "_UpdateMii"))
			child2.connect("_featUpdate2", Callable(self, "_change_feat"))
	for child in tabs.get_children(): 
		for child2 in child.get_children():
			for child3 in child2.get_child(0).get_children():
				child3.connect("_featUpdate", Callable(self, "_UpdateMii"))
				child3.connect("_featUpdate2", Callable(self, "_change_feat"))
#				else:
#					for child5 in child3.get_children():
#						child5.connect("_Minipressed",self,"_change_tab_mini")
		#for child3 in child.get_child(child.get_index()):
		#	print(child3)
			#child2.connect("_featUpdate",self,"_UpdateMii")
			#print(child3)
			#child3.connect("_Minipressed",self,"_change_tab_mini")
	get_tree().get_root().connect("size_changed", Callable(self, "_viewport_update"))
	call_deferred("_viewport_update")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_UpdateMiiBody()
	if Event != null and not InputEventMouseButton:
		prevMosPos = Event.get_relative()
	var cam = $SubViewportContainer/SubViewport.get_camera_3d()
	#shader_ignore_cam.transform = cam.transform
	if Input.is_action_pressed("move_jump"):
		MiiFaceCamH.rotation_degrees.y = lerp(MiiFaceCamH.rotation_degrees.y,0,0.2)
		MiiFaceCamV.rotation_degrees.x = lerp(MiiFaceCamV.rotation_degrees.x,0,0.2)
	if MiiCamRot == true:
		#if Input.is_action_pressed("backspace")!=true:
		MiiCamRotating = true
		#print("rotating")
		#prevMosPos = get_viewport().get_mouse_position()
		if get_viewport().get_mouse_position().x <= get_viewport().get_visible_rect().size.x/2:
			_MiiCamRotatingGO(delta)
		#$ViewportContainer/Viewport/MiiScene/MiiGrp/LargeCam/MiiFullCam.current = false
		#$ViewportContainer/Viewport/MiiScene/MiiGrp/CameraHori/CameraVert/MiiFaceCam.current = true
	else:
		MiiCamRotating = false
		MiiFaceCamH.rotation_degrees.x = lerp(MiiFaceCamH.rotation_degrees.x,0.0,1.0)
		MiiFaceCamV.rotation_degrees.y = lerp(MiiFaceCamH.rotation_degrees.y,0.0,1.0)
		#$ViewportContainer/Viewport/MiiScene/MiiGrp/LargeCam/MiiFullCam.current = true
		#$ViewportContainer/Viewport/MiiScene/MiiGrp/CameraHori/CameraVert/MiiFaceCam.current = false
func _viewport_update():
	var window_size = get_window().size
	#$ViewportContainer/Viewport.size = (window_size / Globals.pixelize_amount).ceil()
	#print(window_size, " new ", $ViewportContainer/Viewport.size)

func _change_tab(new):
	current_tab = new
	if new == 9:
		MiiCamLarge = true
	else:
		MiiCamLarge = false
	#print("yay")
	_change_tab_mini(0,"Hair")
	for child in buttons.get_children(): child._update(new)
#	for child in tabs.get_children(): 
#		print(child.get_child_count())
#		for child2 in child.get_child(0).get_child(0).get_children():
#			if child2.name != "MiniTab":
#				print(child2.name)
#				_UpdateFeatureBut(child2)
	for child in tabs.get_children(): 
		for child2 in child.get_children():
			for child3 in child2.get_child(0).get_children():
				if child3.name != "MiniTab" and child3.name !="Height":
					print(child2.name)
					#child3._update(new)
					_UpdateFeatureBut(child3)

				
	for child in tabs.get_children():
		child.visible = child.get_index() == new
	for child in minitabs.get_children():
		child.visible = child.get_index() == new
#		if child.get_index() == new: $"%bplabel".text = child.name

func _change_feat(new,feat):
	#current_tab = new
#	for child in tabs.get_children(): 
#		for child2 in child.get_child(0).get_child(0).get_children():
#			#if get_node(child2).name != "MiniTab":
#			print(child2.name)
#			_UpdateFeatureBut(child2)
	for child in tabs.get_children(): 
		for child2 in child.get_children():
			for child3 in child2.get_child(0).get_children():
				if child3.name != "MiniTab" and child3.name != 'Height':
					print(child2.name)
					_UpdateFeatureBut(child3)
				
#	for child in tabs.get_children():
#		child.visible = child.get_index() == new
#		if child.get_index() == new: $"%bplabel".text = child.name

func _change_tab_mini(new,feat):
#	for child in tabs.get_children():
#		if tabs.get_child_count() > child.get_index():
#			child.visible = child.name == tab
	for child in minitabs.get_children(): 
		for child2 in child.get_children():
			#if child2.name != "MiniTab":
			print(child2.name)
			child2._update(new)
	for child in tabs.get_children():
		for child2 in child.get_children():
			child2.visible = child2.get_index() == new

#	for child in $Faceline / tabs.get_children():
#		child.visible = child.name == new

func _input(event):
	#print(event)
	Event = event
	if event is InputEventMouseMotion:
		prevMosPos = event.get_relative()
		MosSpeed = event.get_velocity()
	if event is InputEventMouseButton and event.pressed == true:
		if event.button_index == 1 :
			
			MiiCamRot = true
			print("left clicked")
			
	if event is InputEventMouseButton and event.pressed == false:
		if event.button_index == 1 :
			MiiCamRot = false
			print("left click release")


func _on_MiiCamArea_mouse_entered():
	#MiiCamRot = true
	#print("mouse enter")
	pass


func _on_MiiCamArea_mouse_exited():
	#MiiCamRot = false
	#print("mouse leave")
	pass

func _UpdateMiiBody():
	MiiFaceCamH.position.y = MiiHead.global_position.y
	#MiiBody.get_child(0).get_child(0).get_child(1).get_surface_override_material(0).albedo_color = MiiHead.FavColour
	#MiiBody.get_child(0).get_child(0).get_child(3).get_surface_override_material(0).albedo_color = MiiHead.FavColour
	#MiiBody.get_child(0).get_child(0).get_child(2).get_surface_override_material(0).albedo_color = Color("40464e")
	#MiiBody.get_child(0).get_surface_material(0).set_shader_param("G_Replace", MiiHead.SkinColour)
	#CalcArmatureScaleTest(MiiSkele,MiiHead.MiiHeight,MiiHead.MiiWeight)
#	var scale = Vector3(1,1,1)
#	scale.x = (MiiHead.MiiWeight * (MiiHead.MiiHeight * 0.003671875 + 0.4)) / 128.0 + MiiHead.MiiHeight * 0.001796875 + 0.4;
#	scale.y = MiiHead.MiiHeight * 0.006015625 + 0.5;
#	scale.z = scale.x	
#	MiiSkele.scale = scale * Vector3(1.42,1.42,1.42)
#	MiiHead.scale = Vector3(70.443,70.443,70.443)/Vector3(MiiSkele.scale.x,MiiSkele.scale.y,MiiSkele.scale.z)
func _MiiCamRotatingGO(delta):
	if MiiCamLarge == false:
		nextMosPos = get_viewport().get_mouse_position()
		#if MosSpeed >= Vector2(0.05,0.05):
		MiiFaceCamH.rotate_object_local(Vector3.UP, -prevMosPos.x * 0.0025)
		MiiFaceCamV.rotate_object_local(Vector3(1,0,0), -prevMosPos.y *0.0025)
		prevMosPos=Vector2(0,0)
	else:
		#MiiFaceCamH.rotation_degrees.x = Vector3(lerp(MiiFaceCamH.rotation_degrees.x,0,1))
		#MiiFaceCamV.rotation_degrees.y = Vector3(lerp(MiiFaceCamH.rotation_degrees.y,0,1))
		pass
func _UpdateMii(ID, Feature):
	match Feature:
		"Head":
			MiiHead.HeadID = ID
			MiiHead._MakeHead()
			MiiHead._MakeHair()
			MiiHead._NosePosition()
			MiiHead._AssignGlass()
		"Make":
			MiiHead.MakeID = ID
			MiiHead._MakeHead()
		"Hair":
			MiiHead.HairID = ID
			MiiHead._MakeHair()
			MiiHead._MakeHead()
		"HairFlip":
			if MiiHead.HairFlip == false:
				MiiHead.HairFlip = true
			else:
				MiiHead.HairFlip = false
			MiiHead._MakeHair()
		"FaceLT":
			MiiHead.FacelineID = ID
			MiiHead._MakeHead()
		"Brow":
			MiiHead.BrowRot = MiiHead.BrowRot + MiiHead.FFLGetBrowRotOffset(MiiHead.BrowID) - MiiHead.FFLGetBrowRotOffset(ID)
			MiiHead.BrowID = ID
			MiiHead.BrowRot = clamp(MiiHead.BrowRot,0,11)
			MiiHead._AssignBrows()
			MiiHead._BrowPosition()
		"BrowH":
			MiiHead.BrowHori = clamp(MiiHead.BrowHori+ID,0,12)
			MiiHead._BrowPosition()
		"BrowV":
			MiiHead.BrowVert = clamp(MiiHead.BrowVert+ID,3,18)
			MiiHead._BrowPosition()
		"BrowS":
			MiiHead.BrowSize = clamp(MiiHead.BrowSize+ID,0,8)
			MiiHead._BrowPosition()
		"BrowR":
				MiiHead.BrowRot = clamp(MiiHead.BrowRot+ID,0,11)
				MiiHead._BrowPosition()
		"BrowStr":
				MiiHead.BrowStretch = clamp(MiiHead.BrowStretch+ID,0,6)
				MiiHead._BrowPosition()
	#MiiHead._GenerateMii()

func _UpdateFeatureBut(n):
	match n.feat:
		"Head":
			n._update(MiiHead.HeadID)
			print("head")
			print(MiiHead.HeadID)
		"Make":
			n._update(MiiHead.MakeID)
			print("makeupp")
			print(MiiHead.MakeID)
		"Hair":
			n._update(MiiHead.HairID)
		"FaceLT":
			n._update(MiiHead.FacelineID)
		"Brow":
			n._update(MiiHead.BrowID)
		"BrowH":
			n._update(MiiHead.BrowHori)
		"BrowV":
			n._update(MiiHead.BrowVert)
		"BrowS":
			n._update(MiiHead.BrowSize)
		"BrowR":
			n._update(MiiHead.BrowRot)
		"BrowStr":
			n._update(MiiHead.BrowStretch)
		"HairFlip":
			n._update(MiiHead.HairFlip)
	#MiiHead._GenerateMii()
	
var MiiHairTable = {
  33: 0,
  47: 1,
  40: 2,
  37: 3,
  32: 4,
  107: 5,
  48: 6,
  51: 7,
  55: 8,
  70: 9,
  44: 10,
  66: 11,
  52: 12,
  50: 13,
  38: 14,
  49: 15,
  43: 16,
  31: 17,
  56: 18,
  68: 19,
  62: 20,
  115: 21,
  76: 22,
  119: 23,
  64: 24,
  81: 25,
  116: 26,
  121: 27,
  22: 28,
  58: 29,
  60: 30,
  87: 31,
  125: 32,
  117: 33,
  73: 34,
  75: 35,
  42: 36,
  89: 37,
  57: 38,
  54: 39,
  80: 40,
  34: 41,
  23: 42,
  86: 43,
  88: 44,
  118: 45,
  39: 46,
  36: 47,
  45: 48,
  67: 49,
  59: 50,
  65: 51,
  41: 52,
  30: 53,
  12: 54,
  16: 55,
  10: 56,
  82: 57,
  128: 58,
  129: 59,
  14: 60,
  95: 61,
  105: 62,
  100: 63,
  6: 64,
  20: 65,
  93: 66,
  102: 67,
  27: 68,
  4: 69,
  17: 70,
  110: 71,
  123: 72,
  8: 73,
  106: 74,
  72: 75,
  3: 76,
  21: 77,
  0: 78,
  98: 79,
  63: 80,
  90: 81,
  11: 82,
  120: 83,
  5: 84,
  74: 85,
  108: 86,
  94: 87,
  124: 88,
  25: 89,
  99: 90,
  69: 91,
  35: 92,
  13: 93,
  122: 94,
  113: 95,
  53: 96,
  24: 97,
  85: 98,
  83: 99,
  71: 100,
  131: 101,
  96: 102,
  101: 103,
  29: 104,
  7: 105,
  15: 106,
  112: 107,
  79: 108,
  1: 109,
  109: 110,
  127: 111,
  91: 112,
  26: 113,
  61: 114,
  103: 115,
  2: 116,
  77: 117,
  18: 118,
  92: 119,
  84: 120,
  9: 121,
  19: 122,
  130: 123,
  97: 124,
  104: 125,
  46: 126,
  78: 127,
  28: 128,
  114: 129,
  126: 130,
  111: 131,
};

func _CreateFeatureButton(Feature):
	var FeatButton = preload("res://mods/Timimimi.Mii/Assets/Node/Menu/maker_feat_button.tscn")
	match Feature:
		"Hair":
			pass
			


func CalcArmatureScaleTest(player, MiiHeight, MiiWeight):
	var scale = Vector3(1,1,1)
	scale.x = (MiiWeight * (MiiHeight * 0.003671875 + 0.4)) / 128.0 + MiiHeight * 0.001796875 + 0.4;
	scale.y = MiiHeight * 0.006015625 + 0.5;
	scale.z = scale.x
	var HeadBoneTransform = MiiSkele.get_bone_rest(16).scaled(Vector3(1,1,1)/scale)
	var HeadScale
	var HeadBoneTransformP = MiiSkele.get_bone_pose(16).scaled(Vector3(1,1,1)/scale)

	#MiiSkele.scale = scale
	#pelvis
	#MiiSkele.set_bone_rest(0,CalcBoneScaleR(player,scale,0))
	
	#arml
	MiiSkele.set_bone_rest(5,CalcBoneScaleR(MiiSkele,scale,5))

	#armr
	MiiSkele.set_bone_rest(10,CalcBoneScaleR(MiiSkele,scale,10))
	#legl
	MiiSkele.set_bone_rest(15,CalcBoneScaleR(MiiSkele,scale,15))
	#legr
	MiiSkele.set_bone_rest(16,CalcBoneScaleR(MiiSkele,scale,16))
	
#	MiiSkele.set_bone_rest(11,HeadBoneTransform)
	
func CalcBoneScaleR(player,scale,bone):
	var BoneTransform = MiiSkele.get_bone_rest(int(bone))
	BoneTransform = BoneTransform.scaled(scale)
	return BoneTransform
func CalcBoneScaleP(player,scale,bone):
	var BoneTransform = MiiSkele.get_bone_pose(int(bone)).scaled(scale)
	return BoneTransform




func _on_Height_value_changed(value):
	MiiHead.MiiHeight = value
