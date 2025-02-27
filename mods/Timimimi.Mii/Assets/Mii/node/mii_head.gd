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

# Called when the node enters the scene tree for the first time.
func _ready():
	#MiiFileLoad(PlayerMiiPath)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func MiiFileLoad(FilePath):
	var MiiNameArray = []
	var file = File.new()
	var MiiBytes = file.open(FilePath, File.READ)
	var buffer = file.get_buffer(file.get_length())
	
	#MiiNameArray = buffer.slice(16,38)
	#Name = MiiNameArray.get_string_from_utf16()
	#var MiiBytes= FileAccess.get_file_as_bytes(FilePath)
	HairID = buffer[49]
	FavColourID = buffer[39]
	MiiHeight = buffer[41]
	MiiWeight = buffer[42]
	HeadID = buffer[45]
	SkinID = buffer[46]
	FacelineID = buffer[47]
	MakeID = buffer[48]
	HairID = buffer[49]
	HairColourID = buffer[50]
	HairFlip = bool(buffer[51])
	EyeID = buffer[52]
	EyeColourID = buffer[53]
	EyeSize = buffer[54]
	EyeStretch = buffer[55]
	EyeRot = buffer[56]
	EyeHori = buffer[57]
	EyeVert = buffer[58]
	BrowID = buffer[59]
	BrowColourID = buffer[60]
	BrowSize = buffer[61]
	BrowStretch = buffer[62]
	BrowRot = buffer[63]
	BrowHori = buffer[64]
	BrowVert = buffer[65]
	NoseID = buffer[66]
	NoseSize = buffer[67]
	NoseVert = buffer[68]
	MouthID = buffer[69]
	MouthColourID = buffer[70]
	MouthSize = buffer[71]
	MouthStretch = buffer[72]
	MouthVert = buffer[73]
	BeardColourID = buffer[74]
	BeardID = buffer[75]
	MustacheID = buffer[76]
	MustacheScale = buffer[77]
	MustacheVert = buffer[78]
	GlassID = buffer[79]
	GlassColourID = buffer[80]
	GlassSize = buffer[81]
	GlassVert = buffer[82]
	UseMole = bool(buffer[83])
	MoleSize = buffer[84]
	MoleX = buffer[85]
	MoleY = buffer[86]
	#SnoutHeight = buffer[87]
	if buffer.size() == 86:
		SnoutHeight = 0
	else:
		SnoutHeight = buffer[87]
	_GenerateMii()
	pass #print#(buffer)

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
	_AssignNose()
	_NosePosition()
	_MouthPosition()
	_AssignMouth()
	_MustachePosition()
	_AssignMustache()
	_MustacheColour()
	_MouthColour()
	_AssignBeard()
	#if CharData == null:
	#	pass
	#elif _Amiimal_Check() == true:
	#	_Amiimal_Features(CharData)
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
	FurTex.visible = false
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
		
		
		
func _AssignGlass():
	var Glass = $HeadSet/Glass_0
	var GlassMat = load(str(MaterialPath+"Mii_Hair.material"))
	#var GlassCalc =(GlassVert -11) * -1.5 + 5.0
	var GlassCalc = 0.4547142856 - (GlassVert * 0.01428571428)
	var GlassCalc2 = (0.34 + (GlassSize*0.16))
	var HeadOffset = 0
	match HeadID:
		0,1,3,4,5:
			HeadOffset = 0.0
		2,6,7,11,12:
			HeadOffset = 0.03
		8,10:
			HeadOffset = 0.015
		9:
			HeadOffset = -0.02
	Glass.position = Vector3(0,(GlassCalc+HeadOffset+0.00)*100,27.5)
	Glass.scale  = Vector3(GlassCalc2 , GlassCalc2, GlassCalc2)
	_setMiiCmnColour('Glass')
	Glass.get_child(0).set_surface_override_material(0,GlassMat)
	Glass.get_child(0).set_surface_override_material(0, Glass.get_child(0).get_surface_override_material(0).duplicate())
	Glass.get_child(0).get_surface_override_material(0).albedo_color = GlassColour
	Glass.get_child(0).get_surface_override_material(0).params_use_alpha_scissor = false
	Glass.get_child(0).get_surface_override_material(0).albedo_texture = load(str(TexPath+"Glass_"+str(GlassID)+".png"))
	Glass.get_child(0).get_surface_override_material(0).flags_transparent = true
	#Glass,get_child(0).get_surface_material(0).flags_albedo_tex_force_srgb = false
	


func _AssignBrows():
	var BrowSpriteL = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL/BrowLSizeBone/BrowLSprite
	var BrowSpriteR = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR/BrowRSizeBone/BrowRSprite
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
	var BrowSpriteL = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL/BrowLSizeBone/BrowLSprite
	var BrowSpriteR = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR/BrowRSizeBone/BrowRSprite
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
	var BrowLBone = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL
	var BrowRBone = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR
	var BrowVertBone = $TexSet/Mask/MiiFaceBone/BrowHeight
	var BrowLBoneSize = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowLEmotion/BrowL/BrowLSizeBone
	var BrowRBoneSize = $TexSet/Mask/MiiFaceBone/BrowHeight/BrowREmotion/BrowR/BrowRSizeBone	
	var eyebrowBaseScale = 0.4 * BrowSize + 1.0;
	var eyebrowBaseScaleY = 0.12 * BrowStretch + 0.64;
	var eyebrowScaleX = 5.0625 * eyebrowBaseScale;
	var eyebrowScaleY = 4.5 * eyebrowBaseScale * eyebrowBaseScaleY;
	var eyebrowSpacingX = BrowHori * SPACING_MUL
	BrowRBone.position = Vector2((-eyebrowSpacingX+32)*baseScale-265,0)
	BrowLBone.position = Vector2((eyebrowSpacingX-32)*baseScale+265,0)
#	BrowLBone.position = Vector2((BrowHori*15 - 30)/2,0)
#	BrowRBone.position = Vector2((-BrowHori*15 + 30)/2 ,0)
	var eyebrowPosY = BrowVert * POS_Y_MUL + POS_Y_ADD_EYEBROW
	BrowVertBone.position = Vector2(baseScale*32, eyebrowPosY*baseScale*0.9)
	BrowLBoneSize.scale = Vector2(0.38+(BrowSize*0.155), (0.38+(BrowSize*0.155)) *   (0.7 + (0.10*BrowStretch)))
	BrowRBoneSize.scale = Vector2(0.38+(BrowSize*0.155), (0.38+(BrowSize*0.155)) *  (0.7 + (0.10*BrowStretch)))
	var browBaseRotate = BrowRot + FFLGetBrowRotOffset(BrowID);
	var browRotateFinal = (browBaseRotate % 32) * (360 / 32);
	var browRotateFinal2 = 11
	if 360 - browRotateFinal == 19 or -360+browRotateFinal == -19:
		BrowLBone.rotation_degrees = browRotateFinal2
		BrowRBone.rotation_degrees = -browRotateFinal2
	else:
		BrowLBone.rotation_degrees = 360-browRotateFinal
		BrowRBone.rotation_degrees = -(360-browRotateFinal)

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
	var EyeSpriteL = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite
	var EyeSpriteR = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeREmotion/EyeR/EyeRSprite
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
	var EyeLBone = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL
	var EyeRBone = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeREmotion/EyeR
	var EyeVertBone = $TexSet/Mask/MiiFaceBone/EyeHeight
	var eyeSpacingX = EyeHori * SPACING_MUL;
	var eyeBaseScaleY = 0.64 + (0.12*EyeStretch)
	var eyeBaseScale = 1.0+(EyeSize*0.4)
	var eyeScaleX = 5.34375 * eyeBaseScale;
	#var eyeScaleY = eyeBaseScale * eyeBaseScaleY * 4.5
	var eyeScaleY = eyeScaleX * (0.64 + (0.12*EyeStretch))
	_EyeRotGrp()
	EyeLBone.position = Vector2((32+eyeSpacingX)*baseScale-265,0)
	EyeRBone.position = Vector2((-32-eyeSpacingX)*baseScale+265,0)
	var eyeBaseRotate = EyeRot - EyeRotationGrp +32;
	var eyeRotateFinal = (eyeBaseRotate % 32) * (360 / 32);
	EyeVertBone.position = Vector2(256, baseScale * (EyeVert * POS_Y_MUL + POS_Y_ADD_EYE))
	EyeLBone.scale = Vector2(eyeScaleX/baseScale/2,eyeScaleY/baseScale/2 )
	EyeRBone.scale = Vector2(eyeScaleX/baseScale/2,eyeScaleY/baseScale/2 )
	
	var eyeRotateFinal2 = 0
	if EyeRot <= 3 and EyeRotationGrp ==4 :
		eyeRotateFinal2 = eyeRotateFinal + 8
		pass #print#("adding 8")
	else:
		eyeRotateFinal2 = eyeRotateFinal
	EyeLBone.rotation_degrees = 360-eyeRotateFinal2
	EyeRBone.rotation_degrees = eyeRotateFinal2
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
	var EyeLSprite = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite
	var EyeRSprite = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeREmotion/EyeR/EyeRSprite
	pass #print#(EyeLSprite)
	_setMiiCmnColour("Eye")
	#EyeLSprite.material = EyeMat
	#EyeRSprite.material = EyeMat
	#EyeLSprite.material = EyeLSprite.material.duplicate()
	#EyeRSprite.material = EyeRSprite.material.duplicate()
	EyeLSprite.material = ShaderMaterial.new()
	EyeLSprite.material.gdshader = EyeShader
	EyeRSprite.material = ShaderMaterial.new()
	EyeRSprite.material.gdshader = EyeShader
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
		

func _NosePosition():
	var NoseSet = $HeadSet/NoseSet
	#var NosePos = Vector3(0,0.05*((NoseVert - 8)*1.5) - 0.005,0.26)
	var NosePos = Vector3(0,100*(0.375 - (0.015*NoseVert)),26)
	var NosePos2 = Vector3(0,(NoseVert-(8.0*-1.5))-0.5,26)
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
			HeadOffset =3
		8,10:
			HeadOffset = 1.5
		9:
			HeadOffset = -2
	NoseSet.position = Vector3(0.0,HeadOffset,0.0) + NosePos2

func _AssignMouth():
	var MouthSprite = $TexSet/Mask/MiiFaceBone/MouthBone/MouthSprite
	#var MouthWolSprite = $WolfMouth
	var MouthTex = str(TexPath+"Mouth_"+str(MouthID)+".png")
	if ResourceLoader.exists(MouthTex):
		MouthSprite.texture = load(MouthTex)
		$TexSet/Mouth/MouthSprite.texture = load(MouthTex)
	else:
		pass

func _MouthPosition():
	var MouthBone = $TexSet/Mask/MiiFaceBone/MouthBone
	var mouthBaseScale = 0.4 * MouthSize + 1.0;
	var mouthBaseScaleY = 0.12 * MouthStretch + 0.64;
	var mouthScaleX = 6.1875 * mouthBaseScale;
	var mouthScaleY = 4.5 * mouthBaseScale * mouthBaseScaleY;
	var mouthFinalPosY =  MouthVert * POS_Y_MUL + POS_Y_ADD_MOUTH
	#MouthBone.position = Vector2(412+(MouthHori*25),471 + (MouthVert*17) - (baseScale*0.6))
	MouthBone.position = Vector2(FaceResolution/2,mouthFinalPosY*baseScale)
	#MouthBone.scale = Vector2(0.2 + (MouthSize*0.2),(0.2 + (MouthSize*0.2)*(0.7+(MouthStretch*0.1))))
	MouthBone.scale = Vector2(mouthScaleX/baseScale/2,(mouthScaleX/baseScale/2)*(0.64+(MouthStretch*0.12)))

func _MouthColour():
	var MouthSprite = $TexSet/Mask/MiiFaceBone/MouthBone/MouthSprite
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
	MouthSprite.material = ShaderMaterial.new()
	MouthSprite.material.gdshader = MouthShader
	MouthSprite.material.set_shader_parameter("B_Replace", Color("ffffff"))
	MouthSprite.material.set_shader_parameter("R_Replace", MouthCLower)
	MouthSprite.material.set_shader_parameter("G_Replace", MouthCUpper)
	AmiiMouthSprite.material = ShaderMaterial.new()
	AmiiMouthSprite.material.gdshader = MouthShader
	AmiiMouthSprite.material.set_shader_parameter("B_Replace", Color("ffffff"))
	AmiiMouthSprite.material.set_shader_parameter("R_Replace", MouthCLower)
	AmiiMouthSprite.material.set_shader_parameter("G_Replace", MouthCUpper)



func _MustachePosition():
	var MustacheBone = $TexSet/Mask/MiiFaceBone/MustacheBone
	var mustacheBaseScale = 0.4 * MustacheScale + 1.0;
	var mustacheScaleX = 4.5 * mustacheBaseScale;
	var mustacheScaleY = 9.0 * mustacheBaseScale;
	var mustachePosY = MustacheVert * POS_Y_MUL + POS_Y_ADD_MUSTACHE;
	MustacheBone.position = Vector2(32*baseScale,(mustachePosY*baseScale))
	MustacheBone.scale = Vector2(mustacheScaleX/baseScale/2,mustacheScaleX/baseScale/2)
	
func _AssignMustache():
	var MustacheSprite = $TexSet/Mask/MiiFaceBone/MustacheBone/MustacheSprite
	var MustacheTex = str(TexPath+"Mustache_"+str(MustacheID)+".png")
	if ResourceLoader.exists(MustacheTex):
		MustacheSprite.texture =  load(MustacheTex)
	else:
		pass

func _MustacheColour():
	var MustacheSprite = $TexSet/Mask/MiiFaceBone/MustacheBone/MustacheSprite
	_setMiiCmnColour('Beard')
	MustacheSprite.modulate = BeardColour

func _AssignMole():
	var MoleSprite = $TexSet/Mask/MiiFaceBone/MoleBone/MoleSprite
	var MoleBone = $TexSet/Mask/MiiFaceBone/MoleBone
	var moleScale= 0.4 * MoleSize + 2.0;

	var molePosX = MoleX * POS_X_MUL + POS_X_ADD_MOLE;
	var molePosY = MoleY * POS_Y_MUL + POS_Y_ADD_MOLE;
	if UseMole == false:
		MoleSprite.visible = false
	else:
		MoleSprite.visible = true
		MoleBone.position = Vector2((molePosX*baseScale),(molePosY*baseScale)- (baseScale*0.6))
		MoleBone.scale = Vector2(moleScale/baseScale/2 , moleScale/baseScale/2 )

func _AssignBeard():
	var node = $HeadSet/Beard
	var BeardTex = str(TexPath+"Beard_"+str(BeardID - 3)+".png")
	var BeardMat = load(str(MaterialPath+"Mii_Hair.material"))
	var FacelineBeardTexNode = $TexSet/Faceline/Facial/Beard
	print(BeardTex)
	if ResourceLoader.exists(BeardTex) == true:
		print(BeardTex)
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
var eye_blink = true

var blink_time = 0
var blink_amount = 0
var emote_time = 0
var reset_time = 60
var used_mouths = []
var CharData
@onready var blink_texture = preload("res://mods/Timimimi.Mii/Assets/Mii/AFLResHigh_2_3_texture/Eye_26.png")

func _physics_process(delta):
	if Engine.get_process_frames() % 10 == 0:
		_MiiToneBody()
	if reset_time > 0:
		reset_time -= 1
		if reset_time <= 0:
			talk_mouth = null
			_AssignMouth()
#			_update_mouth()
	if blink_time > 0:
		blink_time -= 1
		if blink_time <= 0:
			blink_amount -= 1
			_AssignEyes()
#			_update_eyes()
	if emote_time > 0:
		emote_time -= 1
		if emote_time <= 0:
			temp_eye = null
			temp_mouth = null
#			_update_eyes()
#			_update_mouth()
			_AssignEyes()
			_AssignMouth()

func _update_eyes():
	var eye = set_eye
	var allow_alt_eye = true
	
	if temp_eye:
		eye = temp_eye
		allow_alt_eye = false
	if blink_time > 0:
		eye = blink_texture if not alt_blink else alt_blink
		allow_alt_eye = false
	
	if eye == set_eye:
		$TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite.flip_h = false
	else :
		$TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite.flip_h = false
	
	$TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite.texture = eye
	$TexSet/Mask/MiiFaceBone/EyeHeight/EyeREmotion/EyeR/EyeRSprite.texture = eye if not (allow_alt_eye and alt_eye) else alt_eye

func _update_mouth():
	var mouth = set_mouth
	if temp_mouth: mouth = temp_mouth
	if talk_mouth: mouth = talk_mouth
	$TexSet/Mask/MiiFaceBone/MouthBone/MouthSprite.texture = mouth
	$TexSet/Mouth/MouthSprite.texture = mouth
	#$mouth_r.texture = mouth

func _setup_face(data):
	match data["species"]:
		"species_cat":
			#$AnimationPlayer.play("cat_face")
			species = "species_cat"
		"species_dog":
			#$AnimationPlayer.play("dog_face")
			species = "species_dog"
	#CharData = data
	if data["nose"] != "":
		var nose = Globals.cosmetic_data[data["nose"]]["file"]
		$Nose.texture = nose.icon
	if _Amiimal_Check() == true:
		_Amiimal_Features(data)
	if _Amiimal_Check() == false:
		_MiiToneBody()

func _MiiToneBody():
	if _Amiimal_Check() == false and PlayerNode != null:
		PlayerNode.body_mesh.material_override.set_shader_parameter("albedo", SkinColour)
		PlayerNode.body_mesh.material_override.set_shader_parameter("albedo_secondary", SkinColour)
	return "Yahoo"

func _on_blink_timer_timeout():
	if canBlink == true:
		$blink_timer.wait_time = randf_range(2.0, 10.0)
		if not eye_blink: return 
		
		var double = false
		if randf() < 0.15:
			double = true
			$blink_timer.wait_time = 0.2
		
		$blink_timer.start()
		
		if emoting: return 
		
		blink_time = 15 if not double else 6
		_update_eyes()

func _emote(emotion, duration):
	var eye
	var mouth
	var RegEye = str(TexPath+"Eye_"+str(EyeID)+".png")
	var RegMouth = str(TexPath+"Mouth_"+str(MouthID)+".png")
	var EyeSpriteL = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeLEmotion/EyeL/EyeLSprite
	var EyeSpriteR = $TexSet/Mask/MiiFaceBone/EyeHeight/EyeREmotion/EyeR/EyeRSprite
	var MouthSprite = $TexSet/Mask/MiiFaceBone/MouthBone/MouthSprite
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
			toggleERColor
			toggleELColor
			
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
	_update_eyes()
	_update_mouth()

func _talk():
	if used_mouths == []:
		used_mouths = [preload("res://mods/Timimimi.Mii/Assets/Mii/model/head/temp/Mouth_36.png"), load(str(TexPath+"Mouth_"+str(MouthID)+".png"))]
	var frame = randi() % used_mouths.size()
	
	talk_mouth = used_mouths[frame]
	used_mouths.remove(frame)
	reset_time = 15
	_update_mouth()

func _show_blush(show):
	$TexSet/Faceline/FaceMake/Blush.visible = show
	
func AMIIMAL_SECTION():
	pass
	
func _Amiimal_Check() -> bool:
	if SnoutHeight == 0:
		#$TexSet/Faceline/Amiimal.visible = false
		return false
	else:
		#$TexSet/Faceline/Amiimal.visible = true
		return true
		
func _Amiimal_Features(data):
	var DataMain = PlayerNode.cosmetic_data
	var EarSet = $HeadSet/EarSet
	var BodyMat = preload("res://Assets/Shaders/player_skins.tres")
	var MiiMat = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kemo01_m_003.material")
	var CatEar = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kmFaceCatEar.glb")
	var CatSnout = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kmFaceCatSnout.glb")
	var CatNose = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kmFaceCatNose.glb")
	var CatEarInstance = CatEar.instantiate()
	var CatSnoutInstance = CatSnout.instantiate()
	var CatNoseInstance = CatNose.instantiate()
	var CatEarTex = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalTex/cat_ear.png")
	var CatTex = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalTex/cat_facePaint.png")
	var WolEar = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kmFaceWolEar.glb")
	var WolSnout = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalModel/kmFaceWolSnout.glb")
	var WolTex = preload("res://mods/Timimimi.Mii/Assets/Mii/AmiimalTex/wolf_facePaint.png")
	var WolEarInstance = WolEar.instantiate()
	var WolSnoutInstance = WolSnout.instantiate()
	var FurTex = $TexSet/Faceline/Amiimal/Fur
	var MainFurTex = $TexSet/Faceline/Amiimal/SkinToneOverride
	var NoseSet = $HeadSet/NoseSet
	var SnoutSet = $HeadSet/SnoutSet
	var Mouth = $TexSet/Mask/MiiFaceBone/MouthBone/MouthSprite
	var MouthBone = $TexSet/Mask/MiiFaceBone/MouthBone
	var AmiimalFaceSet = $TexSet/Faceline/Amiimal
	var MiiFacePattern = str("res://mods/Timimimi.Mii/Assets/Mii/AmiimalTex/mii_"+str(DataMain.species)+"_"+str(DataMain.pattern)+".png")
	var pattern = Globals.cosmetic_data[DataMain["pattern"]]["file"]
	#CatEarInstance.material_override.set_shader_param("texture_albedo", pattern.body_pattern[0])
	var primary_color = Globals.cosmetic_data[DataMain["primary_color"]]["file"]
	var secondary_color = Globals.cosmetic_data[DataMain["secondary_color"]]["file"] if pattern.body_pattern[0] else Globals.cosmetic_data[DataMain["primary_color"]]["file"]
	for n in EarSet.get_children():
			EarSet.remove_child(n)
			n.queue_free()
	for n in SnoutSet.get_children():
			SnoutSet.remove_child(n)
			n.queue_free()
	FurTex.visible = false
	species = DataMain.species
	$Mouth.rotation_degrees = Vector3(0,0,0)
	AmiimalFaceSet.visible = true
	if ForeMeshNode != null:
		#ForeMeshNode.get_surface_material(0).albedo_color = secondary_color.main_color
		ForeMeshNode.get_surface_override_material(0).albedo_color = Color('ffffff')
		pass
	match species:
		"species_cat":
			#CatEar.material
			$Nose.visible = true
			$Mouth.visible = false
			$Nose.position = Vector3(0,0.274,0.48)
			FurTex.texture = CatTex
			EarSet.add_child(CatEarInstance)
			SnoutSet.add_child(CatSnoutInstance)
			#SnoutSet.add_child(CatNoseInstance)
			if ResourceLoader.exists(MiiFacePattern) == true:
				FurTex.texture = load(MiiFacePattern)
				FurTex.visible = true
			pass #print#("Pattern:"+ str(pattern.body_pattern[1]))
			CatEarInstance.get_child(0).set_surface_override_material(0,BodyMat)
			CatEarInstance.get_child(0).set_surface_override_material(0, CatEarInstance.get_child(0).get_surface_override_material(0).duplicate())
			CatEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("texture_albedo", pattern.body_pattern[1])
			CatEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo", primary_color.main_color)
			CatEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo_secondary", secondary_color.main_color)
			CatSnoutInstance.get_child(0).set_surface_override_material(0,BodyMat)
			CatSnoutInstance.get_child(0).set_surface_override_material(0, CatSnoutInstance.get_child(0).get_surface_override_material(0).duplicate())
			CatSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("texture_albedo", pattern.body_pattern[1])
			CatSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo", primary_color.main_color)
			CatSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo_secondary", secondary_color.main_color)
			#CatNoseInstance.get_child(0).set_surface_material(0,MiiMat)
			#CatNoseInstance.get_child(0).set_surface_material(0, CatNoseInstance.get_child(0).get_surface_material(0).duplicate())
			
			MainFurTex.color = secondary_color.main_color
			FurTex.modulate =  primary_color.main_color
			HairMeshNode.get_surface_override_material(0).set_shader_parameter("albedo",secondary_color.main_color + Color(0.1,0.1,0.1))
			NoseSet.visible = false
			Mouth.visible = false
		"species_dog":
			$Nose.visible = true
			$Mouth.visible = true
			$Mouth.scale = Vector3(MouthBone.scale.x*0.191,MouthBone.scale.y*0.191,1)
			$Mouth.position = Vector3(0,0.165,0.71)
			$Nose.position = Vector3(0,0.27,0.74)
			$Mouth.rotation_degrees = Vector3(11,0,0)
			FurTex.texture = WolTex
			EarSet.add_child(WolEarInstance)
			SnoutSet.add_child(WolSnoutInstance)
			if ResourceLoader.exists(MiiFacePattern) == true:
				FurTex.texture = load(MiiFacePattern)
				FurTex.visible = true
			WolEarInstance.get_child(0).set_surface_override_material(0,BodyMat)
			WolEarInstance.get_child(0).set_surface_override_material(0, WolEarInstance.get_child(0).get_surface_override_material(0).duplicate())
			WolEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("texture_albedo", pattern.body_pattern[2])
			WolEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo", primary_color.main_color)
			WolEarInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo_secondary", secondary_color.main_color)
			WolSnoutInstance.get_child(0).set_surface_override_material(0,BodyMat)
			WolSnoutInstance.get_child(0).set_surface_override_material(0, WolSnoutInstance.get_child(0).get_surface_override_material(0).duplicate())
			WolSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("texture_albedo", pattern.body_pattern[2])
			WolSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo", primary_color.main_color)
			WolSnoutInstance.get_child(0).get_surface_override_material(0).set_shader_parameter("albedo_secondary", secondary_color.main_color)
			#FurTex.visible = true
			MainFurTex.color = secondary_color.main_color
			FurTex.modulate =  primary_color.main_color
			HairMeshNode.get_surface_override_material(0).set_shader_parameter("albedo",secondary_color.main_color + Color(0.1,0.1,0.1))
			NoseSet.visible = false
			Mouth.visible = false

