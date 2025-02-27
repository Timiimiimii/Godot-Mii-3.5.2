extends SubViewport
var save_png_path = "user://Mii/render.png"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$player_face.MiiFileLoad("res://mods/Timimimi.Mii/Assets/Dummy/charinfo/Cammy.charinfo")
	#CreatePic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$player_face._GenerateMii()
	pass

func CreatePic():
	var aspect = size.x/size.y;
	var fovy = 2 * atan2(43.2 / aspect, 500.0);
	#print(rad_to_deg(fovy))
	$Camera3D.fov = rad_to_deg(fovy)
	$Camera3D.position = Vector3(0.0, 34.5, 600.0)
	$Camera3D.look_at(Vector3(0.0, 34.5, 0.0), Vector3(0.0, 1.0, 0.0))
	#var img = get_viewport().get_texture()
	#img.flip_y()
	#img.save_png(save_png_path)


func _on_Timer_timeout():
	CreatePic()
