extends Viewport
var save_png_path = "user://Mii/render.png"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$player_face.MiiFileLoad("res://mods/Timimimi.Mii/Assets/Dummy/charinfo/Timothy.charinfo")
	CreatePic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$player_face._GenerateMii()
	pass

func CreatePic():
	var aspect = size.x/size.y;
	var fovy = 2 * atan2(43.2 / aspect, 500.0);
	print(rad2deg(fovy))
	$Camera.fov = rad2deg(fovy)
	$Camera.translation = Vector3(0.0, 34.5, 600.0)
	$Camera.look_at(Vector3(0.0, 34.5, 0.0), Vector3(0.0, 1.0, 0.0))
	var img = get_viewport().get_texture().get_data()    
	img.flip_y()
	img.save_png(save_png_path)


func _on_Timer_timeout():
	CreatePic()
