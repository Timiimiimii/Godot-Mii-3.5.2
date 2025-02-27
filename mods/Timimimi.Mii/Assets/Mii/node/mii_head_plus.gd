extends Node3D
#var Mii
var canBlink = true
@export var Name = 'Mii'
var MiiHeight = 63
var MiiWeight = 63
@export var FaceResolution = 512
@export var HairID:int = 33
@export var HeadID:int = 0
@export var HairFlip:bool = false
@export var HairColourID:int = 1

@export var SkinID:int = 0
var FacelineID:int = 0
var MakeID:int = 0

@export var BrowID:int = 0
@export var BrowColourID:int = 0
var BrowSize:int = 0
var BrowStretch:int = 0
var BrowRot:int = 0
var BrowHori:int = 0
var BrowVert:int = 0
var BrowRotationGrp:int


var EyeSize:int = 0
var EyeStretch:int = 0
var EyeRot:int = 0
var EyeHori:int = 0
var EyeVert:int = 0
var EyeRotationGrp:int

@export var EyeID:int = 2
@export var EyeColourID:int = 8

@export var GlassID:int = 0
@export var GlassColourID:int = 0
var GlassVert:int = 0
var GlassSize:int = 0

var NoseID:int = 0
var NoseSize:int = 0
var NoseVert:int = 0

@export var MouthColourID:int = 0
@export var MouthID:int = 0

var MouthSize:int = 0
var MouthStretch:int = 0
var MouthVert:int = 0

@export var BeardColourID:int = 0
@export var BeardID:int = 0
@export var MustacheID:int = 0
var MustacheScale:int = 0
var MustacheVert:int = 0

var UseMole:bool = false
var MoleSize:int = 0
var MoleX:int = 0
var MoleY:int = 0

@export var FavColourID:int = 0
var SnoutHeight = 0

var PlayerNode
var HairMeshNode
var ForeMeshNode
var HairColour = Color("000000")
var SkinColour = Color("000000")
var BrowColour = Color("000000")
var EyeColour = Color('000000')
var GlassColour = Color('000000')
var MouthCUpper = Color("000000")
var BeardColour = Color("000000")
var MouthCLower = Color("000000")
@export var FavColour = Color("ff0000")
#var path
var ShapePath = "res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_shape/"
var TexPath = "res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/"
var CharinfoPath = "user://Mii/charinfo/"
var PlayerMiiPath = "user://Mii/charinfo/Player/Player.charinfo"
var MaterialPath = "res://mods/Timimimi.Mii/Assets/Material/"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var POS_X_ADD    = 3.5323312
var POS_Y_ADD    = 4.629278;

var SPACING_MUL  = 0.88961464;
var POS_X_MUL    = 1.7792293;
var POS_Y_MUL    = 1.0760943;

var POS_Y_ADD_EYE        = POS_Y_ADD + 13.822246;
var POS_Y_ADD_EYEBROW    = POS_Y_ADD + 11.920528;
var POS_Y_ADD_MOUTH      = POS_Y_ADD + 24.629572;
var POS_Y_ADD_MUSTACHE   = POS_Y_ADD + 27.134275;
var POS_X_ADD_MOLE       = POS_X_ADD + 14.233834;
var POS_Y_ADD_MOLE       = POS_Y_ADD + 11.178394 + 2 * POS_Y_MUL;
var baseScale = FaceResolution * (1.0/64.0)

var MiiGenerated:bool = false
var MiiEyeBaseRot
var MiiBrowBaseRot
var MiiEyeBasePos:Vector2
var MiiBrowBasePos:Vector2
var MiiFaceAnimation = false

var BrowRSprite
var BrowLSprite
var EyeRSprite
var EyeLSprite

signal MiiReady

#@export @onready var EyeLSprite = $TexSet/Mask/Offset/EyeLSprite
#@export @onready var EyeRSprite = $TexSet/Mask/Offset/EyeRSprite
#
#@export @onready var BrowLSprite = $TexSet/Mask/Offset/BrowLSprite
#@export @onready var BrowRSprite = $TexSet/Mask/Offset/BrowRSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	#MiiFileLoad("user://Mii/charinfo/Player/Fer.charinfo")
	#emit_signal("MiiReady")
	call_deferred("emit_signal","MiiReady")
#	if MiiGenerated == false:
#		_GenerateMii()
	EyeLSprite = $TexSet/Mask/Offset/EyeLSprite
	EyeRSprite = $TexSet/Mask/Offset/EyeRSprite
	BrowLSprite = $TexSet/Mask/Offset/BrowLSprite
	BrowRSprite = $TexSet/Mask/Offset/BrowRSprite
#

func MiiFileLoad(FilePath):
	#var file = FileAccess.open("res://save_game.dat", FileAccess.READ)
	#var content = file.get_file_as_bytes()
	var MiiBytes= FileAccess.get_file_as_bytes(FilePath)
	print(MiiBytes)
	var Name= MiiBytes.slice(16,38).get_string_from_utf16()
	print(Name)
	FavColourID = MiiBytes.decode_u8(39)
	MiiHeight = MiiBytes.decode_u8(41)
	MiiWeight = MiiBytes.decode_u8(42)
	HeadID = MiiBytes.decode_u8(45)
	SkinID = MiiBytes.decode_u8(46)
	FacelineID = MiiBytes.decode_u8(47)
	MakeID = MiiBytes.decode_u8(48)
	HairID = MiiBytes.decode_u8(49)
	HairColourID = MiiBytes.decode_u8(50)
	HairFlip = bool(MiiBytes.decode_u8(51))
	EyeID = MiiBytes.decode_u8(52)
	EyeColourID = MiiBytes.decode_u8(53)
	EyeSize = MiiBytes.decode_u8(54)
	EyeStretch = MiiBytes.decode_u8(55)
	EyeRot = MiiBytes.decode_u8(56)
	EyeHori = MiiBytes.decode_u8(57)
	EyeVert = MiiBytes.decode_u8(58)
	BrowID = MiiBytes.decode_u8(59)
	BrowColourID = MiiBytes.decode_u8(60)
	BrowSize = MiiBytes.decode_u8(61)
	BrowStretch = MiiBytes.decode_u8(62)
	BrowRot = MiiBytes.decode_u8(63)
	BrowHori = MiiBytes.decode_u8(64)
	BrowVert = MiiBytes.decode_u8(65)
	NoseID = MiiBytes.decode_u8(66)
	NoseSize = MiiBytes.decode_u8(67)
	NoseVert = MiiBytes.decode_u8(68)
	MouthID = MiiBytes.decode_u8(69)
	MouthColourID = MiiBytes.decode_u8(70)
	MouthSize = MiiBytes.decode_u8(71)
	MouthStretch = MiiBytes.decode_u8(72)
	MouthVert = MiiBytes.decode_u8(73)
	BeardColourID = MiiBytes.decode_u8(74)
	BeardID = MiiBytes.decode_u8(75)
	MustacheID = MiiBytes.decode_u8(76)
	MustacheScale = MiiBytes.decode_u8(77)
	MustacheVert = MiiBytes.decode_u8(78)
	GlassID = MiiBytes.decode_u8(79)
	GlassColourID = MiiBytes.decode_u8(80)
	GlassSize = MiiBytes.decode_u8(81)
	GlassVert = MiiBytes.decode_u8(82)
	UseMole = bool(MiiBytes.decode_u8(83))
	MoleSize = MiiBytes.decode_u8(84)
	MoleX = MiiBytes.decode_u8(85)
	MoleY = MiiBytes.decode_u8(86)
	_GenerateMii()

func _GenerateMii():
	
	_MakeHead()
	_MakeHair()
	_AssignGlass()
	_setMiiFvColour()
	_setHeadColour()
	_AssignBrows()
	_BrowColour()
	_BrowPosition()
	_BrowRotGrp()
	_EyeColour()
	_AssignEyes()
	_EyePosition()
	_AssignMole()
	_NosePosition()
	_AssignNose()

	_MouthPosition()
	_AssignMouth()
	_MustachePosition()
	_AssignMustache()
	_MustacheColour()
	_MouthColour()
	_AssignBeard()
	MiiGenerated = true
	
func _MakeHair():
	var HairPath = str(ShapePath+"Hair1_"+str(HairID)+".glb")
	var HairMat = preload("res://mods/Timimimi.Mii/Assets/Material/Mii_EpicalHair.material")
	var CapPath = str(ShapePath+"Cap1_"+str(HairID)+".glb")
	var CapMat = load(str(MaterialPath+"Mii_Hair.material"))
	var ForePath = str(ShapePath+"Forehead1_"+str(HairID)+".glb")
	var HairSet = $HeadSet/HairSet
	var EarSet = $HeadSet/EarSet
	pass #print#(str(HairPath))
	for n in HairSet.get_children():
			HairSet.remove_child(n)
			n.queue_free()
	if ResourceLoader.exists(str(HairPath)):
		
		var HairInstance = load(HairPath).instantiate()
		#1d1d1d
		HairSet.add_child(HairInstance)
		if HairFlip == true:
			HairInstance.scale = Vector3(-1,1,1)
		else:
			pass
		HairInstance.position = Vector3(0,0,0)
		_setMiiCmnColour('Hair')
		_setMiiFvColour()
		#HairMat.set_shader_param("albedo",HairColour)
		HairInstance.get_child(0).set_surface_override_material(0,HairMat)
		HairInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo",HairColour)
		#HairInstance.get_child(0).lod_min_hysteresis = 1
		#HairInstance.get_child(0).get_surface_material(0).set_shader_param("uv1_scale",Vector3(1,1,1))
		#HairInstance.get_child(0).get_surface_material(0).params_use_alpha_scissor = false
		#MiiBody.get_child(0).get_surface_material(0).set_shader_param("G_Replace", MiiHead.SkinColour)
		HairInstance.get_child(0).set_surface_override_material(0, HairInstance.get_child(0).get_surface_override_material(0).duplicate())
		
#		HairInstance.get_child(0).set_surface_material(0,HairMat)
#		HairMat.albedo_color = HairColour
#		HairInstance.get_child(0).get_surface_material(0).uv1_scale = Vector3(1,1,1)
#		HairInstance.get_child(0).get_surface_material(0).params_use_alpha_scissor = false
#		HairInstance.get_child(0).set_surface_material(0, HairInstance.get_child(0).get_surface_material(0).duplicate())
#
		HairMeshNode = HairInstance.get_child(0)
	if ResourceLoader.exists(str(ForePath)):
		var HeadTex = $TexSet/Faceline.get_texture()
		var ForeInstance = load(ForePath).instantiate()
		HairSet.add_child(ForeInstance)
		if HairFlip == true:
			ForeInstance.scale = Vector3(-1,1,1)
		ForeInstance.get_child(0).set_surface_override_material(0,CapMat)
		_setHeadColour()
		ForeInstance.get_child(0).get_surface_override_material(0).uv1_scale = Vector3(0.0,0.0,0.0)
		ForeInstance.get_child(0).get_surface_override_material(0).albedo_texture = HeadTex
		ForeInstance.get_child(0).get_surface_override_material(0).albedo_color = Color('ffffff')
		#ForeInstance.get_child(0).get_surface_material(0).albedo_color = SkinColour
		ForeMeshNode = ForeInstance.get_child(0)
		ForeInstance.get_child(0).set_surface_override_material(0, ForeInstance.get_child(0).get_surface_override_material(0).duplicate())
	else:
		pass #print#("HairFailedtoLoad")
	if ResourceLoader.exists(str(CapPath)):
			var CapTex = load(TexPath+"Cap_"+str(HairID)+".png")
			var CapInstance = load(CapPath).instantiate()
			HairSet.add_child(CapInstance)
			CapInstance.position = Vector3(0,0,0)
			CapInstance.get_child(0).set_surface_override_material(0,CapMat)
			CapInstance.get_child(0).get_surface_override_material(0).uv1_scale = Vector3(1,1,1)
			CapInstance.get_child(0).get_surface_override_material(0).albedo_texture = CapTex
			CapInstance.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = false
			CapInstance.get_child(0).get_surface_override_material(0).flags_albedo_tex_force_srgb = false
			CapMat.albedo_color = FavColour
			CapInstance.get_child(0).set_surface_override_material(0, CapInstance.get_child(0).get_surface_override_material(0).duplicate())
			CapMat.flags_albedo_tex_force_srgb = true
	match HeadID:
		0,1,3,4,5:
			HairSet.position = Vector3(0,0,0)
			EarSet.position = Vector3(0,0,0)
		2,6,7,11,12:
			HairSet.position = Vector3(0,3,0)
			EarSet.position = Vector3(0,3,0)
		8,10:
			HairSet.position = Vector3(0,1.5,0)
			EarSet.position = Vector3(0,1.5,0)
		9:
			HairSet.position = Vector3(0,-2,0)
			EarSet.position = Vector3(0,-2,0)

func _MakeHead():
	var HeadPath = str(ShapePath+"Faceline_"+str(HeadID)+".glb")
	var HeadMat =  load(str(MaterialPath+"Mii_Hair.material"))
	var MaskPath = str(ShapePath+"Mask_"+str(HeadID)+".glb")
	var MaskMat = load(str(MaterialPath+"Mii_Hair.material"))
	
	var MakeTex = str(TexPath+"FaceMake_"+str(MakeID)+".png")
	var FacelineTex = str(TexPath+"Faceline_"+str(FacelineID)+".png")
	var BeardTex = str(TexPath+"Beard_"+str(BeardID)+".png")
	var SkinModel = $TexSet/Faceline/Base/SkinTone
	var FurTex = $TexSet/Faceline/Amiimal/Fur
	if ResourceLoader.exists(MakeTex):
		$TexSet/Faceline/FaceMake/FaceMake.texture = load(MakeTex)
	if ResourceLoader.exists(BeardTex):
		$TexSet/Faceline/Facial/Beard.texture = load(BeardTex)
	else:
		$TexSet/Faceline/Facial/Beard.texture = load(str(TexPath+"Beard_0.png"))
	if ResourceLoader.exists(FacelineTex):
		$TexSet/Faceline/Faceline/Faceline.texture = load(FacelineTex)
		_setHeadColour()
	#FurTex.visible = false
	SkinModel.color = SkinColour
	
	var node = $HeadSet/FacelineMaskSet
	var HeadTex = $TexSet/Faceline.get_texture()
	#HeadMat.set_texture()
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	if ResourceLoader.exists(str(HeadPath)):

		var HeadInstance = load(HeadPath).instantiate()
		var MaskInstance = load(MaskPath).instantiate()
		node.add_child(HeadInstance)
		HeadInstance.position = Vector3(0,0,0)
		#_setMiiCmnColour('Hair')
		_setHeadColour()
		#HairMat.set_shader_parameter("albedo",HairColour)
		#HeadMat.albedo_texture = HeadTex
		HeadInstance.get_child(0).set_surface_override_material(0,HeadMat)
		HeadInstance.get_child(0).set_surface_override_material(0, HeadInstance.get_child(0).get_surface_override_material(0).duplicate())

		HeadInstance.get_child(0).get_surface_override_material(0).albedo_texture = HeadTex
		HeadInstance.get_child(0).get_surface_override_material(0).uv1_scale = Vector3(0.5,1,1)
		HeadInstance.get_child(0).get_surface_override_material(0).albedo_color = Color("ffffff")
		
		#HairInstance.get_child(0).lod_bias = 0.05
		var MaskTex = $TexSet/Mask.get_texture()
		node.add_child(MaskInstance)
		MaskInstance.position = Vector3(0,0,0)
		MaskInstance.get_child(0).set_surface_override_material(0,MaskMat)
		MaskInstance.get_child(0).set_surface_override_material(0, MaskInstance.get_child(0).get_surface_override_material(0).duplicate())
		#MaskMat.albedo_texture = MaskTex
		#MaskMat.canvas_item_default_texture_repeat = 2
		MaskInstance.get_child(0).get_surface_override_material(0).uv1_scale = Vector3(1,1,1)
		MaskInstance.get_child(0).get_surface_override_material(0).albedo_texture = MaskTex
		MaskInstance.get_child(0).get_surface_override_material(0).flags_transparent = true
		MaskInstance.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = true
		MaskInstance.get_child(0).get_surface_override_material(0).albedo_color = Color("ffffff")
		MaskInstance.get_child(0).get_surface_override_material(0).params_cull_mode = StandardMaterial3D.CULL_BACK
		
		
		
func _AssignGlass():
	var Glass = $HeadSet/Glass_FIX
	var GlassMat = load(str(MaterialPath+"Mii_Glass.material"))
	var GlassCalc =(GlassVert -11) * -1.5 + 5.0
	#var GlassCalc = 0.4547142856 - (GlassVert * 0.01428571428)
	var GlassCalc2 = (0.34 + (GlassSize*0.16))
	var GlassCalc3 = GlassSize*0.15 + 0.4
	var HeadOffset = 0
	match HeadID:
		0,1,3,4,5:
			HeadOffset = 0.0
		2,6,7,11,12:
			HeadOffset = 3
		8,10:
			HeadOffset = 1.5
		9:
			HeadOffset = -2
	Glass.position = Vector3(0,(GlassCalc+HeadOffset+0.00)+24.5,27.5)
	Glass.scale  = Vector3(GlassCalc3 , GlassCalc3, GlassCalc3)
	_setMiiCmnColour('Glass')
	Glass.get_child(0).set_surface_override_material(0,GlassMat)
	Glass.get_child(0).set_surface_override_material(0, Glass.get_child(0).get_surface_override_material(0).duplicate())
	Glass.get_child(0).get_surface_override_material(0).albedo_color = GlassColour
	Glass.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = false
	Glass.get_child(0).get_surface_override_material(0).albedo_texture = load(str(TexPath+"Glass_"+str(GlassID)+".png"))
	Glass.get_child(0).get_surface_override_material(0).flags_transparent = true
	Glass.get_child(0).get_surface_override_material(0).params_cull_mode = StandardMaterial3D.CULL_DISABLED
	#Glass,get_child(0).get_surface_material(0).flags_albedo_tex_force_srgb = false
	


func _AssignBrows():
	var BrowSpriteL = $TexSet/Mask/Offset/BrowLSprite
	var BrowSpriteR = $TexSet/Mask/Offset/BrowRSprite
	var BrowTex = str(TexPath+"Eyebrow_"+str(BrowID)+".png")
	if ResourceLoader.exists(BrowTex):
		BrowSpriteL.texture = load(BrowTex)
		BrowSpriteR.texture = load(BrowTex)
	else:
		pass



func FFLGetBrowRotOffset(type) -> int:
	var ROTATE = [
		6, 6, 5, 7,
		6, 7, 6, 7,
		4, 7, 6, 8,
		5, 5, 6, 6,
		7, 7, 6, 6,
		5, 6, 7, 5,
		6, 6, 6, 6
		];
	return 32 - ROTATE[type];





func _BrowColour():
	var BrowSpriteL = $TexSet/Mask/Offset/BrowLSprite
	var BrowSpriteR = $TexSet/Mask/Offset/BrowRSprite
	_setMiiCmnColour('Brow')
	BrowSpriteL.modulate = BrowColour
	BrowSpriteR.modulate = BrowColour

	
func _BrowPositionOld():
	var BrowLBone = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL
	var BrowRBone = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR
	var BrowVertBone = $TexSet/Mask/MiiFaceBone/BrowHeight
	var BrowLBoneSize = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL/BrowLSizeBone
	var BrowRBoneSize = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR/BrowRSizeBone
	#_BrowRotGrp()
	
	var eyebrowBaseScale = 0.4 * BrowSize + 1.0;
	var eyebrowBaseScaleY = 0.12 * BrowStretch + 0.64;
	var eyebrowScaleX = 5.0625 * eyebrowBaseScale;
	var eyebrowScaleY = 4.5 * eyebrowBaseScale * eyebrowBaseScaleY;
	var eyebrowSpacingX = BrowHori * SPACING_MUL
	BrowLBone.position = Vector2((BrowHori*15 - 30),0)
	BrowRBone.position = Vector2((-BrowHori*15 + 30) ,0)
	var eyebrowPosY = BrowVert * POS_Y_MUL + POS_Y_ADD_EYEBROW
	BrowVertBone.position = Vector2(baseScale*32, eyebrowPosY*baseScale)
	BrowLBoneSize.scale = Vector2(0.38+(BrowSize*0.155), (0.38+(BrowSize*0.155)) *   (0.7 + (0.10*BrowStretch)))
	BrowRBoneSize.scale = Vector2(0.38+(BrowSize*0.155), (0.38+(BrowSize*0.155)) *  (0.7 + (0.10*BrowStretch)))
	var browBaseRotate = BrowRot - BrowRotationGrp+32;
	var browRotateFinal = (browBaseRotate % 32) * (360 / 32);
	var browRotateFinal2 = 0
	if BrowRot < 5 and BrowRotationGrp ==5:
		browRotateFinal2 = browRotateFinal + 8
		pass #print#("adding 8")
	elif BrowRot < 6 and not BrowRotationGrp == 5:
		browRotateFinal2 = browRotateFinal + 8
		pass #print#("adding 8")
	elif BrowRot <= 6 and BrowRotationGrp ==7:
		browRotateFinal2 = browRotateFinal + 8
		pass #print#("adding 8")
	else:
		browRotateFinal2 = browRotateFinal
	BrowLBone.rotation_degrees = 360-browRotateFinal2
	BrowRBone.rotation_degrees = -(360-browRotateFinal2)


func _BrowPosition():
	var eyebrowBaseScale = 0.4 * BrowSize + 1.0;
	var eyebrowBaseScaleY = 0.12 * BrowStretch + 0.64;
	var eyebrowScaleX = 5.0625 * eyebrowBaseScale;
	var eyebrowScaleY = 4.5 * eyebrowBaseScale * eyebrowBaseScaleY;
	var eyebrowSpacingX = BrowHori * SPACING_MUL
#	BrowLBone.position = Vector2((BrowHori*15 - 30)/2,0)
#	BrowRBone.position = Vector2((-BrowHori*15 + 30)/2 ,0)
	var eyebrowPosY = BrowVert * POS_Y_MUL + POS_Y_ADD_EYEBROW
	
	BrowRSprite.position = Vector2(-1*((32+eyebrowSpacingX)*baseScale-265)-9, baseScale * (BrowVert * POS_Y_MUL + POS_Y_ADD_EYEBROW))
	BrowLSprite.position = Vector2(-1*((-32-eyebrowSpacingX)*baseScale+265)+9, baseScale * (BrowVert * POS_Y_MUL + POS_Y_ADD_EYEBROW))
	BrowLSprite.scale = Vector2(eyebrowScaleX/baseScale/2.6,(eyebrowScaleY/baseScale/2.6)*1.1875)
	BrowRSprite.scale = Vector2(eyebrowScaleX/baseScale/2.6,(eyebrowScaleY/baseScale/2.6)*1.1875)
	MiiBrowBasePos = BrowLSprite.position
	var browBaseRotate = BrowRot + FFLGetBrowRotOffset(BrowID);
	var browRotateFinal = (browBaseRotate % 32) * (360 / 32);
	var browRotateFinal2 = 11
	if 360 - browRotateFinal == 19 or -360+browRotateFinal == -19:
		BrowLSprite.rotation_degrees = browRotateFinal2
		BrowRSprite.rotation_degrees = -browRotateFinal2
		MiiBrowBaseRot = browRotateFinal2
		
	else:
		BrowLSprite.rotation_degrees = 360-browRotateFinal
		BrowRSprite.rotation_degrees = -(360-browRotateFinal)
		MiiBrowBaseRot = 360 - browRotateFinal

func _BrowRotGrp():
	var BrowRotArray = [
		6, 6, 5, 7,
		6, 7, 6, 7,
		4, 7, 6, 8,
		5, 5, 6, 6,
		7, 7, 6, 6,
		5, 6, 7, 5,
		
		6, 6, 6, 6
	]
	BrowRotationGrp = BrowRotArray[BrowID]

func _AssignEyes():
	var EyeSpriteL = $TexSet/Mask/Offset/EyeLSprite
	var EyeSpriteR = $TexSet/Mask/Offset/EyeRSprite
	var EyeTex = str(TexPath+"Eye_"+str(EyeID)+".png")
	if ResourceLoader.exists(EyeTex):
		EyeSpriteL.texture = load(EyeTex)
		EyeSpriteR.texture = load(EyeTex)
		EyeSpriteL.material.set_shader_parameter("ReplaceCol",true)
		EyeSpriteR.material.set_shader_parameter("ReplaceCol",true)
		
	else:
		pass
			
func _FFLiiGetAdjustedEyeH(height, type):
	match type:
		0:
			pass
		26:
			if height < 12:
				#eyeFinalScaleY = 12
				pass

func _EyePosition():

	#var EyeVertBone = $TexSet/Mask/MiiFaceBone/EyeHeight
	var eyeSpacingX = EyeHori * SPACING_MUL;
	var eyeBaseScaleY = (0.64 + (0.12*EyeStretch))
	var eyeBaseScale = 1.0+(EyeSize*0.4)
	var eyeScaleX = 5.34375 * eyeBaseScale;
	var eyeScaleY = eyeBaseScale * eyeBaseScaleY * 4.5
	
	#var eyeScaleY = eyeScaleX * (0.64 + (0.12*EyeStretch))
	_EyeRotGrp()
	EyeRSprite.position = Vector2(-1*((32+eyeSpacingX+1)*baseScale-265), baseScale * (EyeVert * POS_Y_MUL + POS_Y_ADD_EYE))
	EyeLSprite.position = Vector2(-1*((-32-eyeSpacingX-1)*baseScale+265), baseScale * (EyeVert * POS_Y_MUL + POS_Y_ADD_EYE))
	var eyeBaseRotate = EyeRot - EyeRotationGrp +32;
	var eyeRotateFinal = (eyeBaseRotate % 32) * (360 / 32);
	MiiEyeBasePos = EyeLSprite.position
	#EyeVertBone.position = Vector2(256, baseScale * (EyeVert * POS_Y_MUL + POS_Y_ADD_EYE))
	EyeLSprite.scale = Vector2(eyeScaleX/baseScale/2.6*1.0,(eyeScaleY/baseScale/2.6)*1.1875*1.0)
	EyeRSprite.scale = Vector2(eyeScaleX/baseScale/2.6*1.0,(eyeScaleY/baseScale/2.6)*1.1875*1.0)
	#print(eyeScaleX/eyeScaleY)
	var eyeRotateFinal2 = 0
	if EyeRot <= 3 and EyeRotationGrp ==4 :
		eyeRotateFinal2 = eyeRotateFinal + 8
		pass #print#("adding 8")
	else:
		eyeRotateFinal2 = eyeRotateFinal
	EyeLSprite.rotation_degrees = -eyeRotateFinal2
	EyeRSprite.rotation_degrees = eyeRotateFinal2
	MiiEyeBaseRot = -eyeRotateFinal2
	pass #print#(EyeLBone.scale)

func _EyeRotGrp():
	var EyeRotArray = [
		3, 4, 4, 4,
		3, 4, 4, 4,
		3, 4, 4, 4,
		4, 3, 3, 4,
		4, 4, 3, 3,
		4, 3, 4, 3,
		3, 4, 3, 4,
		4, 3, 4, 4,
		4, 3, 3, 3,
		4, 4, 3, 3,
		3, 4, 4, 3,
		3, 3, 3, 3,
		3, 3, 3, 3,
		4, 4, 4, 4,
		3, 4, 4, 3,
		4, 4, 4, 4,

		4, 4, 4, 4,
		4, 4, 4, 4,
		4, 4, 4, 4,
		4, 4, 4, 4
	]
	EyeRotationGrp = EyeRotArray[EyeID]
	

func _EyeColour():
	var EyeShader= load(str(MaterialPath+"CanvasRGB_Swap.gdshader"))
	var EyeLSprite = $TexSet/Mask/Offset/EyeLSprite
	var EyeRSprite = $TexSet/Mask/Offset/EyeRSprite
	_setMiiCmnColour("Eye")
	EyeLSprite.material = ShaderMaterial.new()
	EyeLSprite.material.shader = EyeShader
	EyeRSprite.material = ShaderMaterial.new()
	EyeRSprite.material.shader = EyeShader
	EyeLSprite.material.set_shader_parameter("B_Replace", EyeColour)
	EyeRSprite.material.set_shader_parameter("B_Replace", EyeColour)
	EyeLSprite.material.set_shader_parameter("R_Replace", Color("00ffff"))
	EyeRSprite.material.set_shader_parameter("R_Replace", Color("00ffff"))
	EyeLSprite.material.set_shader_parameter("G_Replace", Color("ffffff"))
	EyeRSprite.material.set_shader_parameter("G_Replace", Color("ffffff"))
	EyeLSprite.material.set_shader_parameter("ReplaceCol",true)
	EyeRSprite.material.set_shader_parameter("ReplaceCol",true)
	

	
func _AssignNose():
	var NoseLoad =  str(ShapePath+"Nose_"+str(NoseID)+".glb")
	var LineLoad = str(ShapePath+"Noseline_"+str(NoseID)+".glb")
	var Mat = load(str(MaterialPath+"Mii_Hair.material"))
	var node = $HeadSet/NoseSet
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	if ResourceLoader.exists(LineLoad):
		
		var LineInstance = load(LineLoad).instantiate()
		var LineTex = load(str(TexPath+"Noseline_"+str(NoseID)+".png"))
		node.add_child(LineInstance)
		LineInstance.position = Vector3(0,0,0)
		Mat.albedo_texture = LineTex
		LineInstance.get_child(0).set_surface_override_material(0,Mat)
		LineInstance.get_child(0).get_surface_override_material(0).flags_transparent = true
		LineInstance.get_child(0).get_surface_override_material(0).albedo_color = Color("000000")
		LineInstance.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = true
		LineInstance.get_child(0).set_surface_override_material(0, LineInstance.get_child(0).get_surface_override_material(0).duplicate())
		LineInstance.get_child(0).get_surface_override_material(0).params_cull_mode = StandardMaterial3D.CULL_BACK
	if ResourceLoader.exists(NoseLoad):
		var NoseInstance = load(NoseLoad).instantiate()
		node.add_child(NoseInstance)
		NoseInstance.position = Vector3(0,0,0)
		var HeadTex = $TexSet/Faceline.get_texture()
		NoseInstance.get_child(0).set_surface_override_material(0,Mat)
		_setHeadColour()
		NoseInstance.get_child(0).get_surface_override_material(0).uv1_scale = Vector3(0.01,0.01,0.01)
		NoseInstance.get_child(0).get_surface_override_material(0).albedo_texture = HeadTex
		NoseInstance.get_child(0).get_surface_override_material(0).albedo_color = Color("ffffff")
		NoseInstance.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = false
		NoseInstance.get_child(0).set_surface_override_material(0, NoseInstance.get_child(0).get_surface_override_material(0).duplicate())
		NoseInstance.get_child(0).get_surface_override_material(0).params_cull_mode = StandardMaterial3D.CULL_BACK

func _NosePosition():
	var NoseSet = $HeadSet/NoseSet
	#var NosePos = Vector3(0,0.05*((NoseVert - 8)*1.5) - 0.005,0.26)
	var NosePos = Vector3(0,100*(0.375 - (0.015*NoseVert)),26)
	var NosePos2 = Vector3(0,((NoseVert-8.0)*-1.5),26)
	#ok so lowest is 18
	var HeadOffset=0.0
	#default vert is 9

	#var NoseCalc = 0.4 + (NoseSize * 0.17)
	var NoseCalc = 0.4 + (NoseSize * 0.17)    
	NoseSet.scale = Vector3(NoseCalc,NoseCalc,NoseCalc)
	match HeadID:
		0,1,3,4,5:
			HeadOffset = 0.0
		2,6,7,11,12:
			HeadOffset = 3
		8,10:
			HeadOffset = 1.5
		9:
			HeadOffset = -2
	NoseSet.position = Vector3(0.0,HeadOffset,0.0) + NosePos2 + Vector3(0,24.5,0)

func _AssignMouth():
	var MouthSprite = $TexSet/Mask/Offset/MouthSprite
	#var MouthWolSprite = $WolfMouth
	var MouthTex = str(TexPath+"Mouth_"+str(MouthID)+".png")
	if ResourceLoader.exists(MouthTex):
		MouthSprite.texture = load(MouthTex)
		#$TexSet/Mouth/MouthSprite.texture = load(MouthTex)
	else:
		pass

func _MouthPosition():
	var MouthBone = $TexSet/Mask/Offset/MouthSprite
	var mouthBaseScale = 0.4 * MouthSize + 1.0;
	var mouthBaseScaleY = 0.12 * MouthStretch + 0.64;
	var mouthScaleX = 6.1875 * mouthBaseScale;
	var mouthScaleY = 4.5 * mouthBaseScale * mouthBaseScaleY;
	var mouthFinalPosY =  MouthVert * POS_Y_MUL + POS_Y_ADD_MOUTH 
	#MouthBone.position = Vector2(412+(MouthHori*25),471 + (MouthVert*17) - (baseScale*0.6))
	MouthBone.position = Vector2(0,(mouthFinalPosY-0.0)*baseScale)
	#MouthBone.scale = Vector2(0.2 + (MouthSize*0.2),(0.2 + (MouthSize*0.2)*(0.7+(MouthStretch*0.1))))
	MouthBone.scale = Vector2(mouthScaleX/baseScale/2/1.5,(mouthScaleY/baseScale/2/1.5)*(mouthScaleX/mouthScaleY))

func _MouthColour():
	var MouthSprite = $TexSet/Mask/Offset/MouthSprite
	var AmiiMouthSprite = $TexSet/Mouth/MouthSprite
	_setMiiCmnColour('MouthLower')
	_setMiiUpperLipColour()
#	MouthSprite.material.set_shader_parameter("MouthLower", MouthCLower)
#	MouthSprite.material.set_shader_parameter("MouthUpper", MouthCUpper)
	var MouthShader= load(str(MaterialPath+"CanvasRGB_Swap.gdshader"))
	#_setMiiCmnColour("Mo")
	#EyeLSprite.material = EyeMat
	#EyeRSprite.material = EyeMat
	#EyeLSprite.material = EyeLSprite.material.duplicate()
	#EyeRSprite.material = EyeRSprite.material.duplicate()
	#MouthSprite.material = ShaderMaterial.new()
	#MouthSprite.material = MouthShader
	MouthSprite.material.set_shader_parameter("B_Replace", Color("ffffff"))
	MouthSprite.material.set_shader_parameter("R_Replace", MouthCLower)
	MouthSprite.material.set_shader_parameter("G_Replace", MouthCUpper)



func _MustachePosition():
	var MustacheBone = $TexSet/Mask/Offset/MustacheSprite
	var mustacheBaseScale = 0.4 * MustacheScale + 1.0;
	var mustacheScaleX = 4.5 * mustacheBaseScale;
	var mustacheScaleY = 9.0 * mustacheBaseScale;
	var mustachePosY = MustacheVert * POS_Y_MUL + POS_Y_ADD_MUSTACHE;
	MustacheBone.position = Vector2(0,(mustachePosY*baseScale))
	MustacheBone.scale = Vector2(mustacheScaleX/baseScale/2,mustacheScaleX/baseScale/2)
	
func _AssignMustache():
	var MustacheSprite = $TexSet/Mask/Offset/MustacheSprite
	var MustacheTex = str(TexPath+"Mustache_"+str(MustacheID)+".png")
	if ResourceLoader.exists(MustacheTex):
		MustacheSprite.texture =  load(MustacheTex)
	else:
		pass

func _MustacheColour():
	var MustacheSprite = $TexSet/Mask/Offset/MustacheSprite
	_setMiiCmnColour('Beard')
	MustacheSprite.modulate = BeardColour

func _AssignMole():
	var MoleSprite = $TexSet/Mask/Offset/MoleSprite
	var MoleBone = $TexSet/Mask/Offset/MoleSprite
	var moleScale= 0.4 * MoleSize + 2.0;

	var molePosX = MoleX * POS_X_MUL + POS_X_ADD_MOLE;
	var molePosY = MoleY * POS_Y_MUL + POS_Y_ADD_MOLE;
	if UseMole == false:
		MoleSprite.visible = false
	else:
		MoleSprite.visible = true
		MoleBone.position = Vector2((molePosX*baseScale)-256,(molePosY*baseScale))
		MoleBone.scale = Vector2(moleScale/baseScale/2 , moleScale/baseScale/2 )

func _AssignBeard():
	var node = $HeadSet/Beard
	var BeardTex = str(TexPath+"Beard_"+str(BeardID - 3)+".png")
	var BeardMat = load(str(MaterialPath+"Mii_Hair.material"))
	var FacelineBeardTexNode = $TexSet/Faceline/Facial/Beard
	#print(BeardTex)
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	if ResourceLoader.exists(BeardTex) == true:
		#print(BeardTex)
		FacelineBeardTexNode.texture = load(BeardTex)
		_setMiiCmnColour('Beard')
		FacelineBeardTexNode.modulate = BeardColour
		for n in node.get_children():
				node.remove_child(n)
				n.queue_free()
	else:
		$TexSet/Faceline/Facial/Beard.texture = load(str(TexPath+"Beard_0.png"))
	if BeardID != 0 and BeardID < 4 :
		$TexSet/Faceline/Facial/Beard.texture = load(str(TexPath+"Beard_0.png"))
		var BeardModel = str(ShapePath+"Beard_"+str(BeardID)+".glb")
		var HeadOffset = 0
		for n in node.get_children():
				node.remove_child(n)
				n.queue_free()
		
		var BeardInstance = load(BeardModel).instantiate()
			#1d1d1d
		node.add_child(BeardInstance)
		_setMiiCmnColour('Beard')
		BeardMat.albedo_color = BeardColour
		BeardInstance.get_child(0).set_surface_override_material(0,BeardMat)
		BeardInstance.get_child(0).set_surface_override_material(0, BeardInstance.get_child(0).get_surface_override_material(0).duplicate())
		
		BeardInstance.position = Vector3(0,0,0)
		match HeadID:
			0,1,3,4,5:
				HeadOffset = 0.0
			2,6,7,11,12:
				HeadOffset = -3
			8,10:
				HeadOffset = -1.5
			9:
				HeadOffset = 2
		BeardInstance.position = Vector3(0,HeadOffset,0)
	else:
		#$TexSet/Faceline/Facial/Beard.texture = load(str(TexPath+"Beard_0.png"))
		pass

func _setMiiCmnColour(Type):
	
	var CmnColourTable = [
	Color( 0.1764706, 0.1568628, 0.1568628, 1.0 ),
	Color( 0.2509804, 0.1254902, 0.0627451, 1.0 ),
	Color(0.3607844,0.0941177,0.0392157,1.0),
	Color(0.4862746,0.2274510,0.0784314,1.0),
	Color(0.4705883,0.4705883,0.5019608,1.0),
	Color(0.3058824,0.2431373,0.0627451,1.0),
	Color(0.5333334,0.3450981,0.0941177,1.0),
	Color(0.8156863,0.6274510,0.2901961,1.0),
	Color(0.0000000,0.0000000,0.0000000,1.0),
	Color(0.4235295,0.4392157,0.4392157,1.0),
	Color(0.4000000,0.2352942,0.1725491,1.0),
	Color(0.3764706,0.3686275,0.1882353,1.0),
	Color(0.2745099,0.3294118,0.6588236,1.0),
	Color(0.2196079,0.4392157,0.3450981,1.0),
	Color(0.3764706,0.2196079,0.0627451,1.0),
	Color(0.6588236,0.0627451,0.0313726,1.0),
	Color(0.1254902,0.1882353,0.4078432,1.0),
	Color(0.6588236,0.3764706,0.0000000,1.0),
	Color(0.4705883,0.4392157,0.4078432,1.0),
	Color(0.8470589,0.3215687,0.0313726,1.0),
	Color(0.9411765,0.0470589,0.0313726,1.0),
	Color(0.9607844,0.2823530,0.2823530,1.0),
	Color(0.9411765,0.6039216,0.4549020,1.0),
	Color(0.5490197,0.3137255,0.2509804,1.0),
	Color(0.5176471,0.1490197,0.1490197,1.0),
	Color(1.0000000,0.4509804,0.4000000,1.0),
	Color(1.0000000,0.6509804,0.6509804,1.0),
	Color(1.0000000,0.7529412,0.7294118,1.0),
	Color(0.4509804,0.1803922,0.2313726,1.0),
	Color(0.6000000,0.1215687,0.2392157,1.0),
	Color(0.5411765,0.0901961,0.2431373,1.0),
	Color(0.7098040,0.2431373,0.2588236,1.0),
	Color(0.7803922,0.1176471,0.3372550,1.0),
	Color(0.6901961,0.3254902,0.5058824,1.0),
	Color(0.7803922,0.3294118,0.4313726,1.0),
	Color(0.9803922,0.4588236,0.5921569,1.0),
	Color(0.9882353,0.6745099,0.7882353,1.0),
	Color(1.0000000,0.7882353,0.8470589,1.0),
	Color(0.1921569,0.1098040,0.2509804,1.0),
	Color(0.2156863,0.1568628,0.2392157,1.0),
	Color(0.2980393,0.0941177,0.3019608,1.0),
	Color(0.4352942,0.2588236,0.7019608,1.0),
	Color(0.5215687,0.3607844,0.7215687,1.0),
	Color(0.7529412,0.5137255,0.8000000,1.0),
	Color(0.6588236,0.5764706,0.7882353,1.0),
	Color(0.7725491,0.6745099,0.9019608,1.0),
	Color(0.9333334,0.7450981,0.9803922,1.0),
	Color(0.8235295,0.7725491,0.9294118,1.0),
	Color(0.0980393,0.1215687,0.2509804,1.0),
	Color(0.0705883,0.2470589,0.4000000,1.0),
	Color(0.1647059,0.5098040,0.8313726,1.0),
	Color(0.3411765,0.7058824,0.9490197,1.0),
	Color(0.4784314,0.7725491,0.8705883,1.0),
	Color(0.5372550,0.6509804,0.9803922,1.0),
	Color(0.5176471,0.7411765,0.9803922,1.0),
	Color(0.6313726,0.8901961,1.0000000,1.0),
	Color(0.0431373,0.1803922,0.2117648,1.0),
	Color(0.0039216,0.2392157,0.2313726,1.0),
	Color(0.0509804,0.3098040,0.3490197,1.0),
	Color(0.1372550,0.4000000,0.3882353,1.0),
	Color(0.1882353,0.4941177,0.5490197,1.0),
	Color(0.3098040,0.6823530,0.6901961,1.0),
	Color(0.4784314,0.7686275,0.6196079,1.0),
	Color(0.4980393,0.8313726,0.7529412,1.0),
	Color(0.5294118,0.8980393,0.7137255,1.0),
	Color(0.0392157,0.2901961,0.2078432,1.0),
	Color(0.2627451,0.4784314,0.0000000,1.0),
	Color(0.0078432,0.4588236,0.3843138,1.0),
	Color(0.2117648,0.6000000,0.4392157,1.0),
	Color(0.2941177,0.6784314,0.1019608,1.0),
	Color(0.5725491,0.7490197,0.0392157,1.0),
	Color(0.3882353,0.7803922,0.5333334,1.0),
	Color(0.6196079,0.8784314,0.2588236,1.0),
	Color(0.5882353,0.8705883,0.4941177,1.0),
	Color(0.7333334,0.9490197,0.6666667,1.0),
	Color(0.6000000,0.5764706,0.1686275,1.0),
	Color(0.6509804,0.5843138,0.3882353,1.0),
	Color(0.8000000,0.7529412,0.2235295,1.0),
	Color(0.8000000,0.7254902,0.5294118,1.0),
	Color(0.8509804,0.8000000,0.5098040,1.0),
	Color(0.8352942,0.8509804,0.4352942,1.0),
	Color(0.8352942,0.9019608,0.5137255,1.0),
	Color(0.8470589,0.9803922,0.6156863,1.0),
	Color(0.4901961,0.2705883,0.0000000,1.0),
	Color(0.9019608,0.7333334,0.4784314,1.0),
	Color(0.9960785,0.8862746,0.2901961,1.0),
	Color(0.9803922,0.8705883,0.5098040,1.0),
	Color(0.9686275,0.9176471,0.6117648,1.0),
	Color(0.9803922,0.9725491,0.6078432,1.0),
	Color(0.6509804,0.3019608,0.1176471,1.0),
	Color(1.0000000,0.5882353,0.0509804,1.0),
	Color(0.8196079,0.6078432,0.4117648,1.0),
	Color(1.0000000,0.6980393,0.4000000,1.0),
	Color(1.0000000,0.7607844,0.5490197,1.0),
	Color(0.8980393,0.8117648,0.6941177,1.0),
	Color(0.2549020,0.2549020,0.2549020,1.0),
	Color(0.6078432,0.6078432,0.6078432,1.0),
	Color(0.7450981,0.7450981,0.7450981,1.0),
	Color(0.8627451,0.8431373,0.8039216,1.0),
	Color(1.0000000,1.0000000,1.0000000,1.0)
	]
	match Type:
		'Hair':
			if HairColourID == 8:
				#HairColour = Color("#0e0c0b")
				HairColour = Color(0.118, 0.102, 0.094, 1.000)
			else:
				HairColour = CmnColourTable[HairColourID]
		'Eye':
			EyeColour = CmnColourTable[EyeColourID]
		'Glass':
			GlassColour = CmnColourTable[GlassColourID]
		'Brow':
			pass #print#("Setting Brow colour")
			if BrowColourID == 8:
				BrowColour = Color(0.118, 0.102, 0.094, 1.000)
			else:
				BrowColour = CmnColourTable[BrowColourID]
		'Beard':
			pass #print#("Setting Beard colour")
			if BeardColourID == 8:
				BeardColour = Color(0.118, 0.102, 0.094, 1.000)
			else:
				BeardColour = CmnColourTable[BeardColourID]
		'MouthLower':
			MouthCLower = CmnColourTable[MouthColourID]
				

func _setMiiFvColour():
	var FavColourTable = [
	Color(0.824,0.118,0.078,1.000),
	Color(1.000,0.431,0.098,1.000),
	Color(1.000,0.847,0.125,1.000),
	Color(0.471,0.824,0.125,1.000),
	Color(0.000,0.471,0.188,1.000),
	Color(0.039,0.282,0.706,1.000),
	Color(0.235,0.667,0.871,1.000),
	Color(0.961,0.353,0.490,1.000),
	Color(0.451,0.157,0.678,1.000),
	Color(0.282,0.220,0.094,1.000),
	Color(0.878,0.878,0.878,1.000),
	Color(0.094,0.094,0.078,1.000)
	]
	FavColour = FavColourTable[FavColourID]

func _setHeadColour():
	var SkinColourTable:Array = [
	Color(1.0000000, 0.8274510, 0.6784314, 1.0),
	Color( 1.0000000, 0.7137255, 0.4196079, 1.0),
	Color( 0.8705883, 0.4745099, 0.2588236, 1.0),
	Color( 1.0000000, 0.6666667, 0.5490197, 1.0),
	Color( 0.6784314, 0.3176471, 0.1607844, 1.0),
	Color( 0.3882353, 0.1725491, 0.0941177, 1.0),
	Color( 1.0000000, 0.7450981, 0.6470589, 1.0),
	Color( 1.0000000, 0.7725491, 0.5607844, 1.0),
	Color( 0.5490197, 0.2352942, 0.1372550, 1.0),
	Color( 0.2352942, 0.1764706, 0.1372550, 1.0),
	]
	SkinColour = SkinColourTable[SkinID]

func _setMiiUpperLipColour():
	var UpperLipColourTable:Array = [
	Color( 0.0901961, 0.0784314, 0.0784314, 1.0 ),
	Color( 0.1254902, 0.0627451, 0.0313726, 1.0 ),
	Color( 0.1803922, 0.0470589, 0.0196079, 1.0 ),
	Color( 0.2901961, 0.1372550, 0.0470589, 1.0 ),
	Color( 0.3294118, 0.3294118, 0.3529412, 1.0 ),
	Color( 0.1529412, 0.1215687, 0.0313726, 1.0 ),
	Color( 0.3215687, 0.2078432, 0.0549020, 1.0 ),
	Color( 0.6941177, 0.5019608, 0.1568628, 1.0 ),
	Color( 0.0000000, 0.0000000, 0.0000000, 1.0 ),
	Color( 0.2980393, 0.3058824, 0.3058824, 1.0 ),
	Color( 0.2000000, 0.1176471, 0.0862746, 1.0 ),
	Color( 0.2274510, 0.2196079, 0.1137255, 1.0 ),
	Color( 0.1647059, 0.1960785, 0.3960785, 1.0 ),
	Color( 0.1529412, 0.3058824, 0.2431373, 1.0 ),
	Color( 0.1882353, 0.1098040, 0.0313726, 1.0 ),
	Color( 0.3960785, 0.0392157, 0.0196079, 1.0 ),
	Color( 0.0627451, 0.0941177, 0.2039216, 1.0 ),
	Color( 0.4627451, 0.2627451, 0.0000000, 1.0 ),
	Color( 0.3294118, 0.3058824, 0.2862746, 1.0 ),
	Color( 0.5098040, 0.1882353, 0.0941177, 1.0 ),
	Color( 0.4705883, 0.0470589, 0.0470589, 1.0 ),
	Color( 0.5333334, 0.1254902, 0.1568628, 1.0 ),
	Color( 0.8627451, 0.4705883, 0.3137255, 1.0 ),
	Color( 0.2745099, 0.1176471, 0.0392157, 1.0 ),
	Color( 0.3098040, 0.0901961, 0.0901961, 1.0 ),
	Color( 0.6000000, 0.2705883, 0.2392157, 1.0 ),
	Color( 0.9019608, 0.5215687, 0.5215687, 1.0 ),
	Color( 0.9019608, 0.6313726, 0.6078432, 1.0 ),
	Color( 0.2705883, 0.1098040, 0.1372550, 1.0 ),
	Color( 0.3607844, 0.0745099, 0.1450981, 1.0 ),
	Color( 0.3254902, 0.0549020, 0.1450981, 1.0 ),
	Color( 0.4274510, 0.1450981, 0.1568628, 1.0 ),
	Color( 0.4666667, 0.0705883, 0.2039216, 1.0 ),
	Color( 0.4156863, 0.1960785, 0.3019608, 1.0 ),
	Color( 0.4666667, 0.1960785, 0.2588236, 1.0 ),
	Color( 0.6862746, 0.3215687, 0.4156863, 1.0 ),
	Color( 0.8901961, 0.5490197, 0.6745099, 1.0 ),
	Color( 0.9019608, 0.6705883, 0.7333334, 1.0 ),
	Color( 0.0980393, 0.0549020, 0.1254902, 1.0 ),
	Color( 0.1098040, 0.0784314, 0.1215687, 1.0 ),
	Color( 0.1490197, 0.0470589, 0.1529412, 1.0 ),
	Color( 0.2627451, 0.1568628, 0.4196079, 1.0 ),
	Color( 0.3137255, 0.2156863, 0.4313726, 1.0 ),
	Color( 0.5254902, 0.3607844, 0.5607844, 1.0 ),
	Color( 0.4627451, 0.4039216, 0.5529412, 1.0 ),
	Color( 0.6705883, 0.5647059, 0.8117648, 1.0 ),
	Color( 0.8313726, 0.6274510, 0.8823530, 1.0 ),
	Color( 0.7215687, 0.6666667, 0.8352942, 1.0 ),
	Color( 0.0509804, 0.0627451, 0.1254902, 1.0 ),
	Color( 0.0352942, 0.1254902, 0.2000000, 1.0 ),
	Color( 0.1137255, 0.3568628, 0.5803922, 1.0 ),
	Color( 0.1960785, 0.5921569, 0.8549020, 1.0 ),
	Color( 0.3607844, 0.6784314, 0.7843138, 1.0 ),
	Color( 0.4039216, 0.5254902, 0.8823530, 1.0 ),
	Color( 0.3843138, 0.6235295, 0.8823530, 1.0 ),
	Color( 0.5019608, 0.7803922, 0.9019608, 1.0 ),
	Color( 0.0235295, 0.0901961, 0.1058824, 1.0 ),
	Color( 0.0039216, 0.1215687, 0.1176471, 1.0 ),
	Color( 0.0274510, 0.1568628, 0.1764706, 1.0 ),
	Color( 0.0941177, 0.2784314, 0.2705883, 1.0 ),
	Color( 0.1333334, 0.3450981, 0.3843138, 1.0 ),
	Color( 0.1882353, 0.5450981, 0.5529412, 1.0 ),
	Color( 0.3764706, 0.6901961, 0.5294118, 1.0 ),
	Color( 0.3882353, 0.7490197, 0.6627451, 1.0 ),
	Color( 0.4117648, 0.8078432, 0.6078432, 1.0 ),
	Color( 0.0196079, 0.1450981, 0.1058824, 1.0 ),
	Color( 0.1568628, 0.2862746, 0.0000000, 1.0 ),
	Color( 0.0039216, 0.2745099, 0.2313726, 1.0 ),
	Color( 0.1490197, 0.4196079, 0.3058824, 1.0 ),
	Color( 0.1725491, 0.5411765, 0.0000000, 1.0 ),
	Color( 0.4313726, 0.6000000, 0.0000000, 1.0 ),
	Color( 0.2784314, 0.7019608, 0.4352942, 1.0 ),
	Color( 0.5098040, 0.7921569, 0.1215687, 1.0 ),
	Color( 0.4784314, 0.7843138, 0.3764706, 1.0 ),
	Color( 0.6196079, 0.8549020, 0.5490197, 1.0 ),
	Color( 0.4196079, 0.4039216, 0.1176471, 1.0 ),
	Color( 0.4549020, 0.4078432, 0.2705883, 1.0 ),
	Color( 0.6392157, 0.5960785, 0.0862746, 1.0 ),
	Color( 0.7215687, 0.6392157, 0.4274510, 1.0 ),
	Color( 0.7647059, 0.7098040, 0.3960785, 1.0 ),
	Color( 0.7490197, 0.7647059, 0.3176471, 1.0 ),
	Color( 0.7411765, 0.8117648, 0.3921569, 1.0 ),
	Color( 0.7372550, 0.8823530, 0.4901961, 1.0 ),
	Color( 0.2941177, 0.1607844, 0.0000000, 1.0 ),
	Color( 0.8117648, 0.6313726, 0.3529412, 1.0 ),
	Color( 0.8980393, 0.7764706, 0.1333334, 1.0 ),
	Color( 0.8823530, 0.7647059, 0.3725491, 1.0 ),
	Color( 0.8705883, 0.8156863, 0.4862746, 1.0 ),
	Color( 0.8823530, 0.8745099, 0.4784314, 1.0 ),
	Color( 0.3921569, 0.1803922, 0.0705883, 1.0 ),
	Color( 0.8000000, 0.4705883, 0.0392157, 1.0 ),
	Color( 0.7372550, 0.5098040, 0.2980393, 1.0 ),
	Color( 0.9019608, 0.5725491, 0.2509804, 1.0 ),
	Color( 0.9019608, 0.6431373, 0.4117648, 1.0 ),
	Color( 0.8078432, 0.7137255, 0.5882353, 1.0 ),
	Color( 0.1294118, 0.1294118, 0.1294118, 1.0 ),
	Color( 0.4862746, 0.4862746, 0.4862746, 1.0 ),
	Color( 0.6705883, 0.6705883, 0.6705883, 1.0 ),
	Color( 0.7764706, 0.7568628, 0.7137255, 1.0 ),
	Color( 0.8509804, 0.8509804, 0.8509804, 1.0 )]
	MouthCUpper = UpperLipColourTable[MouthColourID]

func ToggleBoneAnimFace(value):
	MiiFaceAnimation = value

func MiiFaceAnimate():
	var EyeBoneL = $TexSet/MiiAnimBone/EyeLEmotion
	var EyeBoneR = $TexSet/MiiAnimBone/EyeREmotion
	var BrowBoneL = $TexSet/MiiAnimBone/BrowLEmotion
	var BrowBoneR = $TexSet/MiiAnimBone/BrowREmotion
	EyeLSprite.rotation_degrees = EyeBoneL.rotation_degrees + MiiEyeBaseRot
	EyeRSprite.rotation_degrees = EyeBoneR.rotation_degrees - MiiEyeBaseRot
	BrowLSprite.rotation_degrees = BrowBoneL.rotation_degrees + MiiBrowBaseRot
	BrowRSprite.rotation_degrees = BrowBoneR.rotation_degrees - MiiBrowBaseRot
	BrowLSprite.position = BrowBoneL.position + MiiBrowBasePos - Vector2(17,-36)
	BrowRSprite.position = BrowBoneR.position + Vector2(-MiiBrowBasePos.x,MiiBrowBasePos.y)- Vector2(-17,-36)
	EyeLSprite.position = EyeBoneL.position + MiiEyeBasePos
	EyeRSprite.position = EyeBoneR.position + Vector2(-MiiEyeBasePos.x,MiiEyeBasePos.y)
	
func WEBFISHING_STUFF():
	pass

var emoting = false
var species = "species_cat"
var set_eye
var set_mouth
var alt_blink
var alt_eye
var temp_eye
var temp_mouth
var talk_mouth

var eye_mirror = true
@export var eye_blink = true

var blink_time = 0
var blink_amount = 0
var emote_time = 0
var reset_time = 60
var used_mouths = []
var CharData
@onready var blink_texture = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_26.png")



func _emote(emotion, duration):
	var eye
	var mouth
	var RegEye = str(TexPath+"Eye_"+str(EyeID)+".png")
	var RegMouth = str(TexPath+"Mouth_"+str(MouthID)+".png")
	var EyeSpriteL = $TexSet/Mask/Offset/EyeLSprite
	var EyeSpriteR = $TexSet/Mask/Offset/EyeRSprite
	var MouthSprite = $TexSet/Mask/Offset/MouthSprite
	var EyeTex = str(TexPath+"Eye_"+str(EyeID)+".png")
	var toggleELColor = EyeSpriteL.material.set_shader_parameter("ReplaceCol",false)
	var toggleERColor = EyeSpriteR.material.set_shader_parameter("ReplaceCol",false)
	var toggleMColor = MouthSprite.material.set_shader_parameter("ReplaceCol",false)
	var ELColorOn = EyeSpriteL.material.set_shader_parameter("ReplaceCol",true)
	var ERColorOn = EyeSpriteR.material.set_shader_parameter("ReplaceCol",true)
	var MColorOn = MouthSprite.material.set_shader_parameter("ReplaceCol",true)
	match emotion:
		"love":
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_62.png")
			EyeSpriteL.material.set_shader_parameter("ReplaceCol",false)
			EyeSpriteR.material.set_shader_parameter("ReplaceCol",false)
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_38.png")
			
		"happy":
			ELColorOn
			ERColorOn
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_60.png")
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_38.png")
		"angry":
			ELColorOn
			ERColorOn
			eye = load(RegEye)
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_10.png")
			$AnimationPlayer.play("MiiAngry")
		"sad":
			ELColorOn
			ERColorOn
			eye = load(RegEye)
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_12.png")
			$AnimationPlayer.play("MiiSad")
		"surprised":
			ELColorOn
			ERColorOn
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_61.png")
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_36.png")
			$AnimationPlayer.play("MiiSurprise")
			
		"cat":
			ELColorOn
			ERColorOn
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_48.png")
			MouthSprite.scale = MouthSprite.scale * Vector2(2,2)
		"flat":
			eye = load(RegEye)
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_23.png")
		"strum":
			ELColorOn
			ERColorOn
			MColorOn
			mouth = load(RegMouth)
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_79.png")
		"bark":
			ELColorOn
			ERColorOn
			duration = 0.5
			eye = load(RegEye)
			toggleMColor
			if species == "species_cat":
				mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/temp/Mouth_48.png")
				MouthSprite.scale = MouthSprite.scale * Vector2(2,2)
			if species == "species_dog":
				mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/temp/Mouth_49.png")
		"growl":
			ELColorOn
			ERColorOn
			duration = 0.5
			eye = load(RegEye)
			toggleMColor
			if species == "species_cat":
				mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/temp/Mouth_48.png")
				MouthSprite.scale = MouthSprite.scale * Vector2(2,2)
			if species == "species_dog":
				mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/temp/Mouth_49.png")
		"whine":
			ELColorOn
			ERColorOn
			duration = 0.5
			eye = load(RegEye)
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_30.png")
		"bark_ready":
			ELColorOn
			ERColorOn
			MColorOn
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_47.png")
			mouth = load(RegMouth)
		"kiss":
			ELColorOn
			ERColorOn
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_77.png")
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Mouth_32.png")
			duration = 1.0
		"punch":
			ELColorOn
			ERColorOn
			MColorOn
			eye = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_66.png")
			mouth = preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/texture/Mouth_14_RGBA.png")
			duration = 1.0
	
	temp_eye = eye
	temp_mouth = mouth
	emote_time = duration * 60.0
	_AssignEyes()
	_AssignMouth()
